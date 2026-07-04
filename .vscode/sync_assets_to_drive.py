import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
sys.path.insert(0, os.path.join(ROOT_DIR, "src", "tools"))
sys.path.insert(0, SCRIPT_DIR)

from asset_index_builder import extract_google_id, print_box
from assets_manifest import diff as manifest_diff
from assets_manifest import drive_url, load_manifest, save_manifest, scan_assets
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
    os.path.realpath(os.path.join(ROOT_DIR, "assets")),
}


def _ignored(path):
    path = os.path.realpath(path)
    return any(path.startswith(i) for i in IGNORE_DIRS)


def find_and_replace_link(old_url, new_url):
    """A Drive URL is byte-identical only when the uploaded content is
    byte-identical, so replacing every literal occurrence of it project-wide
    is always correct — unlike switching *sources* per field (handled
    separately by apply_asset_source.py), there's no risk of two unrelated
    fields coincidentally needing different treatment here."""
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

            if old_url not in content:
                continue

            with open(path, "w", encoding="utf-8") as f:
                f.write(content.replace(old_url, new_url))
            touched.append(os.path.relpath(path, ROOT_DIR))

    return touched


def build_mod():
    build.run_build(ROOT_DIR, "build")


def main():
    old_manifest = load_manifest()
    manifest = scan_assets(old_manifest)

    old_path_to_hash = {}
    for file_hash, entry in old_manifest.items():
        for path in entry.get("paths", {}):
            old_path_to_hash[path] = file_hash

    needing = [h for h, entry in manifest.items() if not entry.get("driveId")]
    _, _, renamed = manifest_diff(old_manifest, manifest)
    to_reconcile = [
        (file_hash, sorted(new_paths)[0])
        for file_hash, old_paths, new_paths in renamed
        if manifest[file_hash].get("driveId")
    ]

    if not needing and not to_reconcile:
        save_manifest(manifest)
        print_box("NO ASSET CHANGES TO SYNC")
        build_mod()
        return

    service = get_service()
    root_folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    folder_cache = {(): root_folder_id}

    uploaded = 0
    relinked_files = set()
    unwired = []
    old_ids_to_delete = set()

    for file_hash in needing:
        entry = manifest[file_hash]
        paths = list(entry["paths"])
        primary_path = paths[0]
        abs_path = os.path.join(ROOT_DIR, *primary_path.split("/"))
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
                old_id = old_manifest.get(old_hash, {}).get("driveId")
                if old_id:
                    old_ids.add(old_id)

        if not old_ids:
            unwired.append((primary_path, file_id, new_url))
            continue

        for old_id in old_ids:
            old_url = drive_url(old_id)
            touched = find_and_replace_link(old_url, new_url)
            relinked_files.update(touched)
            old_ids_to_delete.add(old_id)

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

    if relinked_files:
        print(f"\n{len(relinked_files)} project file(s) updated with new links:")
        for path in sorted(relinked_files):
            print(f"  {path}")

    if unwired:
        print(f"\n{len(unwired)} file(s) uploaded but not referenced anywhere in the project yet:")
        for path, file_id, new_url in unwired:
            print(f"  {path}  id={file_id}  {new_url}")

    print_box(
        f"ASSETS SYNCED ({uploaded} UPLOADED, {len(relinked_files)} FILES RELINKED, "
        f"{deleted} OLD DELETED, {reconciled} RENAMED)"
    )

    build_mod()


if __name__ == "__main__":
    main()
