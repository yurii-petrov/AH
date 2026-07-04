import hashlib
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import ASSETS_ROOT, print_box, to_relative

MANIFEST_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets_manifest.json")
DRIVE_URL_TEMPLATE = "https://drive.google.com/uc?export=download&id={}"


def drive_url(drive_id):
    return DRIVE_URL_TEMPLATE.format(drive_id) if drive_id else None


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
            path_to_old[path] = (file_hash, meta.get("mtime"), meta.get("size"))

    new_assets = {}

    for root, _, files in os.walk(ASSETS_ROOT):
        for name in files:
            if name == ".DS_Store":
                continue
            abs_path = os.path.join(root, name)
            rel_path = to_relative(abs_path)
            stat = os.stat(abs_path)
            mtime, size = stat.st_mtime, stat.st_size

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
    with open(MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump({"assets": assets}, f, indent=2, ensure_ascii=False)


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

    print_box(f"ASSETS MANIFEST UPDATED ({len(new_assets)} UNIQUE FILES)")


if __name__ == "__main__":
    main()
