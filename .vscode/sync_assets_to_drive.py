import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
sys.path.insert(0, os.path.join(ROOT_DIR, "src", "tools"))
sys.path.insert(0, os.path.join(ROOT_DIR, "src", "tools", "drive"))
sys.path.insert(0, SCRIPT_DIR)

from asset_index_builder import ASSETS_ROOT, extract_google_id, print_box
from assets_manifest import diff as manifest_diff
from assets_manifest import (
    drive_url,
    load_local_snapshot,
    load_manifest,
    save_local_snapshot,
    save_manifest,
    scan_assets,
    to_absolute_asset,
)
from drive_upload import (
    DRIVE_FOLDER_NAME,
    find_folder,
    get_service,
    resolve_drive_dir,
    sync_drive_metadata,
    upload_file,
)

import build

SCAN_EXTENSIONS = (".json", ".lua", ".xml", ".txt")
IGNORE_DIRS = {
    os.path.realpath(os.path.join(ROOT_DIR, ".tts")),
    os.path.realpath(os.path.join(ROOT_DIR, "src/tools")),
    os.path.realpath(os.path.join(ROOT_DIR, ".venv")),
    os.path.realpath(ASSETS_ROOT),
}


def _ignored(path):
    path = os.path.realpath(path)
    return any(path.startswith(i) for i in IGNORE_DIRS)


def find_and_replace_link(old_id, new_id):
    """Search by the bare Drive file id, not the full URL — sidesteps
    TTSModManager's JSON writer sometimes html-escaping "&" as "\\u0026",
    which would otherwise make a plain URL string search miss half the
    occurrences depending on which tool last touched the file. IDs are
    long, high-entropy strings, but only replace inside files that actually
    reference a Drive URL at all, as a cheap sanity check against a
    coincidental match."""
    touched = []

    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if not _ignored(os.path.join(root, d))]
        if _ignored(root):
            continue

        for name in files:
            if not name.endswith(SCAN_EXTENSIONS):
                continue

            path = os.path.join(root, name)
            try:
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
            except (OSError, UnicodeDecodeError):
                continue

            if old_id not in content or "drive.google.com" not in content:
                continue

            with open(path, "w", encoding="utf-8") as f:
                f.write(content.replace(old_id, new_id))
            touched.append(os.path.relpath(path, ROOT_DIR))

    return touched


def build_mod():
    build.run_build(ROOT_DIR, "build")


def pull_asset_layout(local_snapshot, shared_manifest, current):
    """assets/ is gitignored but assets_manifest.json is committed, so a
    teammate's rename arrives via `git pull` as a path change in the shared
    manifest while their own assets/ folder never moved. Comparing disk
    directly against the shared manifest can't tell that apart from "I just
    renamed this myself, it needs to go the other way" — both look exactly
    like "disk disagrees with the shared file". The disambiguator is
    local_snapshot: what MY OWN disk looked like after MY OWN last run here.
    Only pull (rename local to match shared) when my disk still matches
    what I last knew — if it doesn't, I changed it myself since then, and
    that's a push, not a pull; leave it for the diff below to pick up."""
    moved = []

    for file_hash, shared_entry in shared_manifest.items():
        expected_paths = set(shared_entry.get("paths", {}))
        if not expected_paths:
            continue

        snapshot_entry = local_snapshot.get(file_hash)
        snapshot_paths = set(snapshot_entry.get("paths", {})) if snapshot_entry else set()
        if snapshot_paths == expected_paths:
            continue  # shared hasn't moved relative to what I last knew

        current_entry = current.get(file_hash)
        if not current_entry:
            continue  # not present locally at all — a separate "missing content" case

        current_paths = set(current_entry.get("paths", {}))
        if current_paths != snapshot_paths:
            continue  # I already changed this myself since my last run — a push, not a pull

        if current_paths & expected_paths:
            continue  # already sitting at (one of) the expected path(s)

        old_path = sorted(current_paths)[0]
        new_path = sorted(expected_paths)[0]
        old_abs = to_absolute_asset(old_path)
        new_abs = to_absolute_asset(new_path)

        if os.path.isfile(new_abs):
            print(f"SKIP pulling rename ({old_path} -> {new_path}): destination already exists locally")
            continue

        os.makedirs(os.path.dirname(new_abs), exist_ok=True)
        os.rename(old_abs, new_abs)
        moved.append((old_path, new_path))

    return moved


def main():
    shared_manifest = load_manifest()
    local_snapshot = load_local_snapshot()
    if local_snapshot is None:
        # First run on this machine — nothing to compare my own disk against
        # yet, so trust the shared state as the starting point rather than
        # treating every asset as a brand-new local change.
        local_snapshot = shared_manifest

    current = scan_assets(shared_manifest)
    moved = pull_asset_layout(local_snapshot, shared_manifest, current)
    if moved:
        print(f"Pulled {len(moved)} local rename(s) to match the shared layout:")
        for old_path, new_path in moved:
            print(f"  {old_path} -> {new_path}")
        current = scan_assets(shared_manifest)  # re-scan: files just physically moved

    manifest = current

    old_path_to_hash = {}
    for file_hash, entry in local_snapshot.items():
        for path in entry.get("paths", {}):
            old_path_to_hash[path] = file_hash

    needing = [h for h, entry in manifest.items() if not entry.get("driveId")]
    _, _, renamed = manifest_diff(local_snapshot, manifest)
    to_reconcile = [
        (file_hash, sorted(new_paths)[0])
        for file_hash, old_paths, new_paths in renamed
        if manifest[file_hash].get("driveId")
    ]

    if not needing and not to_reconcile:
        save_manifest(manifest)
        save_local_snapshot(manifest)
        print_box("NO ASSET CHANGES TO SYNC")
        build_mod()
        return

    service = get_service()
    root_folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    folder_cache = {(): root_folder_id}

    uploaded = 0
    relinked_files = set()
    unwired = []
    unresolved = []
    old_ids_to_delete = set()

    for file_hash in needing:
        entry = manifest[file_hash]
        paths = list(entry["paths"])
        primary_path = paths[0]
        abs_path = to_absolute_asset(primary_path)
        if not os.path.isfile(abs_path):
            print(f"SKIP (file missing on disk): {abs_path}")
            continue

        subfolder_parts = primary_path.split("/")[1:-1]
        target_folder_id = resolve_drive_dir(service, root_folder_id, subfolder_parts, folder_cache)

        file_id = upload_file(service, target_folder_id, abs_path)
        new_url = drive_url(file_id)
        entry["driveId"] = file_id
        uploaded += 1
        print(f"Uploaded: {primary_path} -> {new_url}")

        old_ids = set()
        for path in paths:
            old_hash = old_path_to_hash.get(path)
            if old_hash and old_hash != file_hash:
                # If old_hash is still present in the *new* scan, its content
                # lives on at some other path (e.g. a duplicate file) and its
                # Drive copy is still legitimately in use — deleting it or
                # redirecting its references to the new upload would corrupt
                # that still-valid, unrelated asset.
                if old_hash in manifest:
                    continue
                old_id = shared_manifest.get(old_hash, {}).get("driveId") or local_snapshot.get(old_hash, {}).get("driveId")
                if old_id:
                    old_ids.add(old_id)

        if not old_ids:
            unwired.append((primary_path, file_id, new_url))
            continue

        for old_id in old_ids:
            touched = find_and_replace_link(old_id, file_id)
            relinked_files.update(touched)
            old_ids_to_delete.add(old_id)

            if not touched:
                # The manifest's previous driveId wasn't found anywhere in the
                # project — a prior sync likely already failed to relink it,
                # so whatever's actually still embedded is even further out
                # of date. Deleting the superseded Drive file is still safe
                # (its content is gone locally either way), but this needs a
                # human to find and fix the real stale reference by hand.
                unresolved.append((primary_path, old_id, new_url))

    deleted = 0
    for old_id in old_ids_to_delete:
        try:
            service.files().delete(fileId=old_id).execute()
            deleted += 1
        except Exception as e:
            print(f"Could not delete superseded Drive file {old_id}: {e}")

    reconciled = 0
    for file_hash, new_path in to_reconcile:
        entry = manifest[file_hash]
        try:
            if sync_drive_metadata(service, entry["driveId"], new_path, root_folder_id, folder_cache):
                reconciled += 1
                print(f"Renamed on Drive: -> {new_path}")
        except Exception as e:
            print(f"Could not rename Drive file {entry['driveId']} to match {new_path}: {e}")

    save_manifest(manifest)
    save_local_snapshot(manifest)

    if relinked_files:
        print(f"\n{len(relinked_files)} project file(s) updated with new links:")
        for path in sorted(relinked_files):
            print(f"  {path}")

    if unwired:
        print(f"\n{len(unwired)} file(s) uploaded but not referenced anywhere in the project yet:")
        for path, file_id, new_url in unwired:
            print(f"  {path}  id={file_id}  {new_url}")

    if unresolved:
        print(f"\n⚠ {len(unresolved)} asset(s) expected an old link in the project but found none —")
        print("  whatever's actually still referenced is stale and needs a manual fix:")
        for path, old_id, new_url in unresolved:
            print(f"  {path}  expected old id={old_id}  new link={new_url}")

    print_box(
        f"ASSETS SYNCED ({uploaded} UPLOADED, {len(relinked_files)} FILES RELINKED, "
        f"{deleted} OLD DELETED, {reconciled} RENAMED"
        + (f", {len(unresolved)} UNRESOLVED" if unresolved else "")
        + ")"
    )

    build_mod()


if __name__ == "__main__":
    main()
