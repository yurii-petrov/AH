import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import (
    ASSETS_ROOT,
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

# Same scope as asset_index_builder.scan()/sync_assets_to_drive.py: asset
# references live not just under objects/ (per-object scripts) but also in
# top-level config.json (e.g. SkyURL) and modsettings/*.json (e.g.
# CustomUIAssets.json) — anywhere TTSModManager decomposes project state to.
IGNORE_DIRS = {
    os.path.realpath(os.path.join(ROOT_DIR, ".tts")),
    os.path.realpath(os.path.join(ROOT_DIR, "src/tools")),
    os.path.realpath(os.path.join(ROOT_DIR, ".venv")),
    os.path.realpath(ASSETS_ROOT),
}


def _ignored(path):
    path = os.path.realpath(path)
    return any(path.startswith(i) for i in IGNORE_DIRS)


def find_json_files():
    json_files = []
    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if not _ignored(os.path.join(root, d))]
        if _ignored(root):
            continue
        for name in files:
            if name.endswith(".json"):
                json_files.append(os.path.join(root, name))
    return sorted(json_files)

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


# -------------------------
# RESOLVE A SINGLE EMBEDDED URL BACK TO ITS CANONICAL CONTENT-HASH, via
# whichever of the three reverse maps matches its form. Shared with
# collect_steam_links.py, which needs the exact same resolution for the
# "old" (pre-Decompose) side of its git diff.
# -------------------------
def resolve_asset_hash(raw_value, path_to_hash, drive_id_to_hash, steam_id_to_hash):
    if "http" not in raw_value and "file:" not in raw_value:
        return None, None

    url = fix_url(normalize(raw_value))
    kind = classify(url)

    if url.lower().startswith("file:"):
        fs_path = path_from_file_url(url)
        asset_path = to_relative_asset(fs_path) if fs_path else None
        # to_relative_asset() only produces a portable "assets/..." string
        # when fs_path actually sits under ASSETS_ROOT — a link pointing
        # elsewhere (stale/foreign path) falls back to "assets/../../..."
        # here, which must not be treated as a hit.
        if asset_path and not asset_path.startswith("assets/.."):
            return path_to_hash.get(asset_path), url
        return None, url

    if kind == "google":
        gid = extract_google_id(url)
        return (drive_id_to_hash.get(gid) if gid else None), url

    if kind == "steam":
        sid = extract_steam_id(url)
        return (steam_id_to_hash.get(sid) if sid else None), url

    return None, url


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
    unresolved = []

    for file_path in find_json_files():
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

            # These are the only three forms the switcher understands as an
            # asset reference — an unrelated http(s) link (Steam workshop
            # page, font CDN, ...) legitimately has no manifest coverage and
            # must not be reported as a problem.
            is_asset_link = url.lower().startswith("file:") or kind in ("google", "steam")
            if not is_asset_link:
                continue

            file_hash, _ = resolve_asset_hash(raw_value, path_to_hash, drive_id_to_hash, steam_id_to_hash)

            if not file_hash:
                # A recognized asset link (file:// under assets/, a Drive
                # link, or a Steam Cloud link) that doesn't match anything in
                # the manifest(s) — e.g. a Drive id that was superseded by a
                # re-upload but never relinked here. Silently skipping this
                # would leave a stale/dead reference in place with no sign
                # anything's wrong.
                unresolved.append((os.path.relpath(file_path, ROOT_DIR), key, url))
                continue

            new_url = desired_url(file_hash, manifest, steam_manifest, source)
            if not new_url:
                missing.append((os.path.relpath(file_path, ROOT_DIR), key, source))
                continue

            if new_url != raw_value:
                fixes_by_file.setdefault(file_path, []).append((raw_value, new_url, key))

    return fixes_by_file, missing, unresolved


# -------------------------
# MAIN
# -------------------------
def main():
    if not SOURCE:
        print("Specify --local, --drive, or --steam (optionally --apply)")
        sys.exit(1)

    manifest = load_manifest()
    # Always loaded, regardless of target: an *existing* embedded reference
    # can be a Steam link even when switching to --local/--drive, and needs
    # this to resolve back to its content-hash.
    steam_manifest = load_steam_manifest()

    fixes_by_file, missing, unresolved = collect_fixes(SOURCE, manifest, steam_manifest)
    files_touched, urls_replaced = apply_replacements(fixes_by_file, APPLY)

    status = "APPLIED" if APPLY else "DRY RUN"
    print_box(f"{SOURCE.upper()} LINKS {status} ({files_touched} FILES, {urls_replaced} URLS)")

    if missing:
        print()
        print(f"No '{SOURCE}' link available (skipped):", len(missing))
        for rel_path, key, source in sorted(missing):
            print(f"  {rel_path} [{key}]")

    if unresolved:
        print()
        print(f"⚠ {len(unresolved)} asset link(s) don't match anything in the manifest(s) — left as-is:")
        for rel_path, key, url in sorted(unresolved):
            print(f"  {rel_path} [{key}]: {url}")


if __name__ == "__main__":
    main()
