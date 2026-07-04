import glob
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import (
    ROOT_DIR,
    build_local_file_url,
    classify,
    extract_google_id,
    extract_steam_id,
    fix_url,
    normalize,
    path_from_file_url,
    print_box,
)
from asset_localizer import apply_replacements
from assets_manifest import drive_url, load_manifest, to_absolute_asset, to_relative_asset

STEAM_MANIFEST_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "steam_manifest.json")
OBJECTS_DIR = os.path.join(ROOT_DIR, "objects")

APPLY = "--apply" in sys.argv
if "--local" in sys.argv:
    SOURCE = "local"
elif "--drive" in sys.argv:
    SOURCE = "drive"
elif "--steam" in sys.argv:
    SOURCE = "steam"
else:
    SOURCE = None


# -------------------------
# LOAD STEAM MANIFEST (hash -> {paths, steamId, steamUrl})
# -------------------------
def load_steam_manifest():
    if not os.path.exists(STEAM_MANIFEST_FILE):
        return {}
    with open(STEAM_MANIFEST_FILE, "r", encoding="utf-8") as f:
        return json.load(f).get("assets", {})


# -------------------------
# BUILD REVERSE LOOKUPS: whatever id/path is embedded in objects/*.json ->
# the canonical content-hash assets_manifest.json/steam_manifest.json know it by.
# -------------------------
def build_reverse_maps(manifest, steam_manifest):
    path_to_hash = {}
    drive_id_to_hash = {}
    for file_hash, entry in manifest.items():
        for path in entry.get("paths", {}):
            path_to_hash[path] = file_hash
        if entry.get("driveId"):
            drive_id_to_hash[entry["driveId"]] = file_hash

    steam_id_to_hash = {}
    for file_hash, entry in steam_manifest.items():
        if entry.get("steamId"):
            steam_id_to_hash[entry["steamId"]] = file_hash

    return path_to_hash, drive_id_to_hash, steam_id_to_hash


def desired_url(file_hash, manifest, steam_manifest, source):
    if source == "local":
        entry = manifest.get(file_hash)
        if not entry or not entry.get("paths"):
            return None
        primary_path = sorted(entry["paths"])[0]
        return build_local_file_url(to_absolute_asset(primary_path))

    if source == "drive":
        entry = manifest.get(file_hash)
        return drive_url(entry["driveId"]) if entry and entry.get("driveId") else None

    if source == "steam":
        entry = steam_manifest.get(file_hash)
        return entry.get("steamUrl") if entry else None

    return None


# -------------------------
# GENERIC RECURSIVE WALKER: yield (last dict key, string value) for every
# string leaf — apply_replacements only needs the last key to scope a
# replacement to that JSON field, not the full path asset_index_builder.walk()
# tracks for its merge-index bookkeeping.
# -------------------------
def walk_strings(obj, key=None):
    if isinstance(obj, dict):
        for k, v in obj.items():
            yield from walk_strings(v, k)
    elif isinstance(obj, list):
        for v in obj:
            yield from walk_strings(v, key)
    elif isinstance(obj, str):
        yield key, obj


# -------------------------
# SCAN objects/**/*.json AND COLLECT (old_url, new_url, key) FIXES
# -------------------------
def collect_fixes(source, manifest, steam_manifest):
    path_to_hash, drive_id_to_hash, steam_id_to_hash = build_reverse_maps(manifest, steam_manifest)

    fixes_by_file = {}
    missing = []

    json_files = sorted(glob.glob(os.path.join(OBJECTS_DIR, "**", "*.json"), recursive=True))

    for file_path in json_files:
        with open(file_path, "r", encoding="utf-8") as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                continue

        for key, raw_value in walk_strings(data):
            if "http" not in raw_value and "file:" not in raw_value:
                continue

            url = fix_url(normalize(raw_value))
            kind = classify(url)

            file_hash = None
            if url.lower().startswith("file:"):
                fs_path = path_from_file_url(url)
                asset_path = to_relative_asset(fs_path) if fs_path else None
                # to_relative_asset() only produces a portable "assets/..."
                # string when fs_path actually sits under ASSETS_ROOT — a
                # link pointing elsewhere (stale/foreign path) falls back to
                # "assets/../../..." here, which must not be treated as a hit.
                if asset_path and not asset_path.startswith("assets/.."):
                    file_hash = path_to_hash.get(asset_path)
            elif kind == "google":
                gid = extract_google_id(url)
                file_hash = drive_id_to_hash.get(gid) if gid else None
            elif kind == "steam":
                sid = extract_steam_id(url)
                file_hash = steam_id_to_hash.get(sid) if sid else None

            if not file_hash:
                continue

            new_url = desired_url(file_hash, manifest, steam_manifest, source)
            if not new_url:
                missing.append((os.path.relpath(file_path, ROOT_DIR), key, source))
                continue

            if new_url != raw_value:
                fixes_by_file.setdefault(file_path, []).append((raw_value, new_url, key))

    return fixes_by_file, missing


# -------------------------
# MAIN
# -------------------------
def main():
    if not SOURCE:
        print("Specify --local, --drive, or --steam (optionally --apply)")
        sys.exit(1)

    manifest = load_manifest()
    steam_manifest = load_steam_manifest() if SOURCE == "steam" else {}

    fixes_by_file, missing = collect_fixes(SOURCE, manifest, steam_manifest)
    files_touched, urls_replaced = apply_replacements(fixes_by_file, APPLY)

    status = "APPLIED" if APPLY else "DRY RUN"
    print_box(f"{SOURCE.upper()} LINKS {status} ({files_touched} FILES, {urls_replaced} URLS)")

    if missing:
        print()
        print(f"No '{SOURCE}' link available (skipped):", len(missing))
        for rel_path, key, source in sorted(missing):
            print(f"  {rel_path} [{key}]")


if __name__ == "__main__":
    main()
