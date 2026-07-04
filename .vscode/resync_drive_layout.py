import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
sys.path.insert(0, os.path.join(ROOT_DIR, "src", "tools"))
sys.path.insert(0, os.path.join(ROOT_DIR, "src", "tools", "drive"))

from asset_index_builder import print_box
from assets_manifest import load_manifest
from drive_upload import DRIVE_FOLDER_NAME, find_folder, get_service, sync_drive_metadata


def main():
    """One-off reconciliation: force every asset's Drive name/folder to match
    what assets_manifest.json currently says, regardless of whether a rename
    was just detected locally. Needed after drift accumulated from an earlier
    desync (a colleague's script run reverted some Drive names independently
    of what any single local sync run would notice) — the day-to-day
    sync_assets_to_drive.py only reacts to renames it sees happen *now*, it
    doesn't re-verify everything that was already supposedly in sync."""
    manifest = load_manifest()

    service = get_service()
    root_folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    folder_cache = {(): root_folder_id}

    checked = 0
    fixed = 0
    failed = []

    for file_hash, entry in manifest.items():
        drive_id = entry.get("driveId")
        paths = entry.get("paths", {})
        if not drive_id or not paths:
            continue

        canonical_path = sorted(paths)[0]
        checked += 1

        try:
            if sync_drive_metadata(service, drive_id, canonical_path, root_folder_id, folder_cache):
                fixed += 1
                print(f"Fixed: {canonical_path}")
        except Exception as e:
            failed.append((canonical_path, drive_id, e))

    if failed:
        print(f"\n{len(failed)} could not be checked/fixed:")
        for path, drive_id, e in failed:
            print(f"  {path}  id={drive_id}  {e}")

    print_box(f"DRIVE LAYOUT RESYNC ({checked} CHECKED, {fixed} FIXED, {len(failed)} FAILED)")


if __name__ == "__main__":
    main()
