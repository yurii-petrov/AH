import os
import re
import shutil
import sys

from asset_index_builder import (
    ASSET_FLATTEN_MOVES,
    ASSETS_ROOT,
    CACHE_FILE_RENAMES,
    DRIVE_PATH_MAP,
    ROOT_DIR,
    URL_REGEX,
    build_local_file_url,
    classify,
    extract_google_id,
    fix_url,
    load_local_files,
    load_tts_index,
    normalize,
    path_from_file_url,
    scan,
)
from asset_localizer import CLOUDSTORAGE_ROOT, apply_replacements

# steam_cache/external_cache were already migrated to the project root earlier
# this session; this consolidates them under assets/ alongside everything else.
ROOT_CACHE_MOVES = tuple(
    (os.path.join(ROOT_DIR, sub), os.path.join(ASSETS_ROOT, sub))
    for sub in ("steam_cache", "external_cache")
)


# -------------------------
# .ttslua FILES AREN'T JSON — `scan()` can't parse them, so their embedded
# google URLs (e.g. hardcoded UI icon tables) need a separate regex pass.
# -------------------------
def collect_ttslua_asset_moves(tts_index, local_files):
    fixes_by_file = {}
    to_copy = []
    unmapped_paths = set()

    ignore_dirs = {
        os.path.realpath(os.path.join(ROOT_DIR, ".tts")),
        os.path.realpath(os.path.join(ROOT_DIR, "src/tools")),
    }

    def ignored(path):
        path = os.path.realpath(path)
        return any(path.startswith(i) for i in ignore_dirs)

    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if not ignored(os.path.join(root, d))]
        if ignored(root):
            continue

        for file in files:
            if not file.endswith(".ttslua"):
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
            except OSError:
                continue

            for match in URL_REGEX.finditer(content):
                raw_url = match.group(0)
                url = fix_url(normalize(raw_url))
                if classify(url) != "google":
                    continue

                gid = extract_google_id(url)
                info = tts_index.get(gid) if gid else None
                if not info:
                    continue

                drive_path = info["drivePath"]
                local = local_files.get(drive_path, {}).get(info["name"])
                if not local:
                    continue

                mapped = DRIVE_PATH_MAP.get(drive_path)
                if not mapped:
                    unmapped_paths.add(drive_path)
                    continue

                dest_path = os.path.join(ASSETS_ROOT, mapped, os.path.basename(local))
                to_copy.append((local, dest_path))

                new_url = build_local_file_url(dest_path)
                fixes_by_file.setdefault(file_path, []).append((raw_url, new_url))

    return fixes_by_file, to_copy, unmapped_paths


# -------------------------
# COPY GOOGLE-DRIVE-SOURCED FILES INTO assets/, REWRITE REFERENCES
# -------------------------
def collect_asset_moves(index):
    fixes_by_file = {}
    to_copy = []
    unmapped_paths = set()

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            google = asset.get("google", {})
            link = google.get("link")
            local = google.get("local")
            drive_path = google.get("drivePath")

            if not link or not local:
                continue

            mapped = DRIVE_PATH_MAP.get(drive_path)
            if not mapped:
                unmapped_paths.add(drive_path)
                continue

            dest_dir = os.path.join(ASSETS_ROOT, mapped)
            dest_path = os.path.join(dest_dir, os.path.basename(local))

            to_copy.append((local, dest_path))

            new_url = build_local_file_url(dest_path)
            fixes_by_file.setdefault(file_path, []).append((link, new_url))

    return fixes_by_file, to_copy, unmapped_paths


# -------------------------
# CATCH ANY file:// LINK STILL POINTING AT THE CLOUDSTORAGE DRIVE MOUNT
# (leftover from earlier runs, before the assets/ folder existed) — resolve
# via the same DRIVE_PATH_MAP the "google" pipeline uses.
# -------------------------
def collect_cloudstorage_leftover_fixes(index):
    fixes_by_file = {}
    to_copy = []
    unmapped_paths = set()

    prefix = CLOUDSTORAGE_ROOT + "/"

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            link = asset.get("other", {}).get("link")
            if not link or not link.lower().startswith("file:"):
                continue

            fs_path = path_from_file_url(link)
            if not fs_path.startswith(prefix):
                continue

            rel = fs_path[len(prefix):]
            drive_path = "Arkham Horror (TTS)/" + os.path.dirname(rel)
            filename = os.path.basename(rel)

            mapped = DRIVE_PATH_MAP.get(drive_path)
            if not mapped:
                unmapped_paths.add(drive_path)
                continue

            dest_path = os.path.join(ASSETS_ROOT, mapped, filename)
            to_copy.append((fs_path, dest_path))

            new_url = build_local_file_url(dest_path)
            if new_url != link:
                fixes_by_file.setdefault(file_path, []).append((link, new_url))

    return fixes_by_file, to_copy, unmapped_paths


def copy_asset_files(to_copy, apply):
    copied = 0
    total_bytes = 0

    for src, dest in sorted(set(to_copy)):
        if os.path.exists(dest) and os.path.getsize(dest) == os.path.getsize(src):
            continue

        print(f"{'COPY' if apply else 'PLAN COPY'}: {src} -> {dest}")
        copied += 1
        total_bytes += os.path.getsize(src)

        if apply:
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            shutil.copy2(src, dest)

    return copied, total_bytes


# -------------------------
# MOVE steam_cache/external_cache UNDER assets/
# -------------------------
def move_root_caches(apply):
    for old_root, new_root in ROOT_CACHE_MOVES:
        if not os.path.isdir(old_root):
            continue

        print(f"{'MOVE' if apply else 'PLAN MOVE'}: {old_root} -> {new_root}")
        if apply:
            os.makedirs(os.path.dirname(new_root), exist_ok=True)
            shutil.move(old_root, new_root)


def collect_root_cache_reference_fixes(index):
    fixes_by_file = {}

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            link = asset.get("other", {}).get("link")
            if not link or not link.lower().startswith("file:"):
                continue

            fs_path = path_from_file_url(link)

            for old_root, new_root in ROOT_CACHE_MOVES:
                if fs_path == old_root or fs_path.startswith(old_root + "/"):
                    new_path = new_root + fs_path[len(old_root):]
                    new_url = build_local_file_url(new_path)
                    if new_url != link:
                        fixes_by_file.setdefault(file_path, []).append((link, new_url))
                    break

    return fixes_by_file


# -------------------------
# CLEANUP-CACHE: drop the library/ + cache/ wrapper folders. library/*
# subfolders move up to assets/* directly; the individual steam_cache/
# external_cache files (previously named by opaque Steam/hash id) get real
# names (CACHE_FILE_RENAMES) and land in the matching content folder instead
# of an anonymous "cache" bucket. Scans every text file directly (not just
# what scan()'s JSON walker covers) so .ttslua sources get fixed too.
# -------------------------
FILE_URL_REGEX = re.compile(r'file:/+[^\s"\']+')


def move_flattened_dirs(apply):
    for old_rel, new_rel in ASSET_FLATTEN_MOVES:
        old_dir = os.path.join(ASSETS_ROOT, old_rel)
        new_dir = os.path.join(ASSETS_ROOT, new_rel)
        if not os.path.isdir(old_dir):
            continue

        print(f"{'MOVE' if apply else 'PLAN MOVE'}: {old_dir} -> {new_dir}")
        if apply:
            os.makedirs(os.path.dirname(new_dir), exist_ok=True)
            shutil.move(old_dir, new_dir)

    for wrapper in ("library", "cache"):
        wrapper_dir = os.path.join(ASSETS_ROOT, wrapper)
        if apply and os.path.isdir(wrapper_dir) and not os.listdir(wrapper_dir):
            os.rmdir(wrapper_dir)


def rename_cache_files(apply):
    renamed = 0
    for sub in ("steam_cache", "external_cache"):
        cache_dir = os.path.join(ASSETS_ROOT, "cache", sub)
        if not os.path.isdir(cache_dir):
            continue

        for fname in sorted(os.listdir(cache_dir)):
            new_rel = CACHE_FILE_RENAMES.get(fname)
            if not new_rel:
                print(f"UNMAPPED cache file (left in place): {sub}/{fname}")
                continue

            old_path = os.path.join(cache_dir, fname)
            new_path = os.path.join(ASSETS_ROOT, *new_rel.split("/"))

            print(f"{'MOVE' if apply else 'PLAN MOVE'}: {old_path} -> {new_path}")
            renamed += 1
            if apply:
                os.makedirs(os.path.dirname(new_path), exist_ok=True)
                shutil.move(old_path, new_path)

        if apply and os.path.isdir(cache_dir) and not os.listdir(cache_dir):
            os.rmdir(cache_dir)

    return renamed


def collect_cleanup_cache_reference_fixes():
    fixes_by_file = {}

    ignore_dirs = {
        os.path.realpath(os.path.join(ROOT_DIR, ".tts")),
        os.path.realpath(os.path.join(ROOT_DIR, "src/tools")),
        os.path.realpath(ASSETS_ROOT),
    }

    def ignored(path):
        path = os.path.realpath(path)
        return any(path.startswith(i) for i in ignore_dirs)

    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if not ignored(os.path.join(root, d))]
        if ignored(root):
            continue

        for file in files:
            if not file.endswith((".json", ".ttslua", ".lua", ".xml", ".txt")):
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
            except OSError:
                continue

            for match in FILE_URL_REGEX.finditer(content):
                link = match.group(0)
                fs_path = path_from_file_url(link)
                if not fs_path or not fs_path.startswith(ASSETS_ROOT + os.sep):
                    continue

                rel = os.path.relpath(fs_path, ASSETS_ROOT).replace(os.sep, "/")

                # cache/<sub>/<hash file> -> its renamed destination
                if rel.startswith("cache/steam_cache/") or rel.startswith("cache/external_cache/"):
                    fname = os.path.basename(rel)
                    new_rel = CACHE_FILE_RENAMES.get(fname)
                    if not new_rel:
                        continue
                    new_abs = os.path.join(ASSETS_ROOT, *new_rel.split("/"))
                    new_url = build_local_file_url(new_abs)
                    if new_url != link:
                        fixes_by_file.setdefault(file_path, []).append((link, new_url))
                    continue

                # library/<x>/... -> <x>/...
                for old_rel, new_rel in ASSET_FLATTEN_MOVES:
                    if rel == old_rel or rel.startswith(old_rel + "/"):
                        new_rel_path = new_rel + rel[len(old_rel):]
                        new_abs = os.path.join(ASSETS_ROOT, *new_rel_path.split("/"))
                        new_url = build_local_file_url(new_abs)
                        if new_url != link:
                            fixes_by_file.setdefault(file_path, []).append((link, new_url))
                        break

    return fixes_by_file


# -------------------------
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    if "--cleanup-cache" in sys.argv:
        fixes_by_file = collect_cleanup_cache_reference_fixes()
        files_touched, urls_replaced = apply_replacements(fixes_by_file, apply)
        move_flattened_dirs(apply)
        renamed = rename_cache_files(apply)

        print()
        print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
        print("Cache files renamed:", renamed)
        print("Files touched:", files_touched)
        print("URLs replaced:", urls_replaced)
        return

    index = scan()

    asset_fixes, to_copy, unmapped_paths = collect_asset_moves(index)
    cache_ref_fixes = collect_root_cache_reference_fixes(index)
    leftover_fixes, leftover_to_copy, leftover_unmapped = collect_cloudstorage_leftover_fixes(index)

    tts_index = load_tts_index()
    local_files = load_local_files()
    ttslua_fixes, ttslua_to_copy, ttslua_unmapped = collect_ttslua_asset_moves(tts_index, local_files)

    to_copy += ttslua_to_copy + leftover_to_copy
    unmapped_paths |= ttslua_unmapped | leftover_unmapped

    copied, total_bytes = copy_asset_files(to_copy, apply)
    move_root_caches(apply)

    replacements_by_file = {}
    for fixes in (asset_fixes, cache_ref_fixes, leftover_fixes, ttslua_fixes):
        for file_path, file_fixes in fixes.items():
            replacements_by_file.setdefault(file_path, []).extend(file_fixes)

    files_touched, urls_replaced = apply_replacements(replacements_by_file, apply)

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Files copied:", copied, f"({total_bytes / 1024 / 1024:.1f} MB)")
    print("Files touched:", files_touched)
    print("URLs replaced:", urls_replaced)

    if unmapped_paths:
        print()
        print("Unmapped drivePath values (skipped):", len(unmapped_paths))
        for p in sorted(unmapped_paths):
            print(" ", p)


if __name__ == "__main__":
    main()
