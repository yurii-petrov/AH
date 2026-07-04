import hashlib
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import ASSETS_ROOT, print_box

MANIFEST_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets_manifest.json")
LOCAL_SNAPSHOT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "local_snapshot.json")
DRIVE_URL_TEMPLATE = "https://drive.google.com/uc?export=download&id={}"


def drive_url(drive_id):
    return DRIVE_URL_TEMPLATE.format(drive_id) if drive_id else None


def to_relative_asset(abs_path):
    """Stored asset paths must stay a portable "assets/..." string — ASSETS_ROOT
    can live anywhere on disk (a plain local folder, a relocated/renamed one, a
    Drive-synced mount, ...) and differs per developer, so resolving against
    ROOT_DIR like the rest of the project's paths would bake a machine-specific
    absolute path into the shared, git-committed manifest."""
    rel = os.path.relpath(abs_path, ASSETS_ROOT)
    return "assets/" + rel.replace(os.sep, "/")


def to_absolute_asset(rel_path):
    parts = rel_path.split("/")
    if parts and parts[0] == "assets":
        parts = parts[1:]
    return os.path.join(ASSETS_ROOT, *parts)


def hash_file(abs_path):
    h = hashlib.sha256()
    with open(abs_path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_manifest():
    if not os.path.exists(MANIFEST_FILE):
        return {}
    with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
        return json.load(f).get("assets", {})


def scan_assets(old_assets):
    path_to_old = {}
    for file_hash, entry in old_assets.items():
        for path, meta in entry.get("paths", {}).items():
            old_mtime = meta.get("mtime")
            path_to_old[path] = (file_hash, round(old_mtime, 3) if old_mtime is not None else None, meta.get("size"))

    new_assets = {}

    for root, dirs, files in os.walk(ASSETS_ROOT):
        # Hidden files/folders (.DS_Store, .git, editor swap files, ...) are
        # never real assets — they must never end up in the manifest or get
        # uploaded to Drive.
        dirs[:] = [d for d in dirs if not d.startswith(".")]

        for name in files:
            if name.startswith("."):
                continue
            abs_path = os.path.join(root, name)
            rel_path = to_relative_asset(abs_path)
            stat = os.stat(abs_path)
            # Rounded to milliseconds: the same instant can come back as a
            # slightly different float (e.g. 1749238876.864 vs
            # .8639998) depending on OS/filesystem — exact equality below
            # would treat that as "changed" and force a needless re-hash,
            # and the raw float would keep "flickering" between machines'
            # own representations in the saved manifest forever.
            mtime, size = round(stat.st_mtime, 3), stat.st_size

            cached = path_to_old.get(rel_path)
            if cached and cached[1] == mtime and cached[2] == size:
                file_hash = cached[0]
            else:
                file_hash = hash_file(abs_path)

            entry = new_assets.setdefault(file_hash, {"paths": {}})
            entry["paths"][rel_path] = {"mtime": mtime, "size": size}

    for file_hash, entry in new_assets.items():
        old_entry = old_assets.get(file_hash)
        if old_entry and old_entry.get("driveId"):
            entry["driveId"] = old_entry["driveId"]

    return new_assets


def save_manifest(assets):
    # sort_keys: os.walk()'s traversal order (and hence dict insertion order)
    # differs by OS/filesystem, so without this every developer's save would
    # reorder the whole file — making git diffs show a total rewrite even
    # when only a handful of entries actually changed.
    with open(MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump({"assets": assets}, f, indent=2, ensure_ascii=False, sort_keys=True)


def load_local_snapshot():
    """What THIS machine's assets/ folder looked like after its own last
    sync run — gitignored, distinct from the shared MANIFEST_FILE. Needed to
    tell "the shared manifest moved without me (pull)" apart from "my own
    disk moved on its own (push)": both look identical (disk != manifest)
    if compared against the shared file alone."""
    if not os.path.exists(LOCAL_SNAPSHOT_FILE):
        return None
    with open(LOCAL_SNAPSHOT_FILE, "r", encoding="utf-8") as f:
        return json.load(f).get("assets", {})


def save_local_snapshot(assets):
    with open(LOCAL_SNAPSHOT_FILE, "w", encoding="utf-8") as f:
        json.dump({"assets": assets}, f, indent=2, ensure_ascii=False, sort_keys=True)


def find_duplicates(assets):
    return [
        (file_hash, sorted(entry["paths"]))
        for file_hash, entry in assets.items()
        if len(entry.get("paths", {})) > 1
    ]


def check_no_duplicates(assets):
    """Two local files that are byte-for-byte identical share one Drive
    upload and one driveId — harmless at first, but if just one of the
    copies is later edited, the pipeline can't tell which project reference
    should follow the edit and which should keep the old link, and refuses
    to guess (see sync_assets_to_drive.py's unresolved/unwired reporting) —
    that then needs a manual fix per affected object. Catching duplicates
    here, at scan time, and refusing to go any further (no upload, no
    build) is cheaper than untangling that later — each local file is
    expected to be its own unique asset."""
    duplicates = find_duplicates(assets)
    if not duplicates:
        return

    print(f"\n✗ {len(duplicates)} duplicate file(s) found — byte-identical copies sharing one Drive upload:")
    for file_hash, paths in duplicates:
        print(f"  {' == '.join(paths)}")
    print("  Each local file must be unique — delete all but one copy, or make their contents different, then run again.")
    sys.exit(1)


def diff(old_assets, new_assets):
    old_hashes = set(old_assets)
    new_hashes = set(new_assets)

    added = new_hashes - old_hashes
    removed = old_hashes - new_hashes
    renamed = []

    for file_hash in old_hashes & new_hashes:
        old_paths = set(old_assets[file_hash]["paths"])
        new_paths = set(new_assets[file_hash]["paths"])
        if old_paths != new_paths:
            renamed.append((file_hash, old_paths, new_paths))

    return added, removed, renamed


def main():
    old_assets = load_manifest()
    new_assets = scan_assets(old_assets)
    added, removed, renamed = diff(old_assets, new_assets)

    save_manifest(new_assets)

    if added:
        print(f"New ({len(added)}):")
        for file_hash in added:
            for path in new_assets[file_hash]["paths"]:
                print(f"  + {path}")

    if removed:
        print(f"Removed ({len(removed)}):")
        for file_hash in removed:
            for path in old_assets[file_hash]["paths"]:
                print(f"  - {path}")

    if renamed:
        print(f"Renamed/moved ({len(renamed)}):")
        for file_hash, old_paths, new_paths in renamed:
            print(f"  {sorted(old_paths)} -> {sorted(new_paths)}")

    check_no_duplicates(new_assets)

    print_box(f"ASSETS MANIFEST UPDATED ({len(new_assets)} UNIQUE FILES)")


if __name__ == "__main__":
    main()
