import os
import re
import sys

from asset_index_builder import (
    ASSETS_ROOT,
    DRIVE_ROOT,
    ROOT_DIR,
    assets_subpath,
    build_local_file_url,
    path_from_file_url,
    scan,
)

CLOUDSTORAGE_ROOT = (
    "/Users/yurii/Library/CloudStorage/GoogleDrive-pe.ur.ur@gmail.com"
    "/.shortcut-targets-by-id/1k8CucmQX-VhCXDhhNpSZieU02tm_jSRF"
    "/Arkham Horror (TTS)"
)

# steam_cache/external_cache were moved out of the Drive mount into the
# project root: Google Drive's virtual filesystem was unreliable for TTS to
# load meshes/assetbundles from directly, even though a plain file copy works.
OLD_CACHE_ROOT = CLOUDSTORAGE_ROOT
NEW_CACHE_ROOT = ROOT_DIR

# steam_cache assets are all saved with a generic ".asset" extension regardless
# of real content (png/jpg/obj/etc). TTS refuses to load local file:// URLs with
# an unrecognized extension, so ambiguous ones get a same-content symlink here
# under a name with the correct extension, and the URL points at the symlink.
LOCAL_CACHE_DIR = "/Users/yurii/AH/assets_dump/local_cache"

MAGIC_EXTENSIONS = (
    (b"\x89PNG", ".png"),
    (b"\xff\xd8\xff", ".jpg"),
    (b"ID3", ".mp3"),
    (b"UnityFS", ".unity3d"),
    (b"%PDF", ".pdf"),
)

HTML_MARKERS = ("<!doctype html", "<html")

MPEG_SYNC_MASK = 0xE0


# -------------------------
# DETECT REAL EXTENSION FROM FILE CONTENT
# -------------------------
def detect_extension(local_path: str):
    try:
        with open(local_path, "rb") as f:
            head = f.read(256)
    except OSError:
        return None

    for magic, ext in MAGIC_EXTENSIONS:
        if head.startswith(magic):
            return ext

    if len(head) >= 2 and head[0] == 0xFF and (head[1] & MPEG_SYNC_MASK) == MPEG_SYNC_MASK:
        return ".mp3"

    try:
        text = head.decode("ascii")
    except UnicodeDecodeError:
        text = head.decode("utf-8", errors="ignore")

    stripped = text.lstrip().lower()
    if any(stripped.startswith(marker) for marker in HTML_MARKERS):
        return ".html"

    obj_markers = ("v ", "vt ", "vn ", "f ", "o ", "g ", "#", "mtllib", "usemtl")
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if lines and any(lines[0].startswith(marker) for marker in obj_markers):
        return ".obj"

    return None


# -------------------------
# CREATE/REUSE AN EXTENSION-CORRECTED SYMLINK FOR A REAL FILE PATH
# -------------------------
def resolve_real_path(fs_path: str) -> str:
    if not fs_path.lower().endswith(".asset"):
        return fs_path

    ext = detect_extension(fs_path)
    if not ext:
        return fs_path

    os.makedirs(LOCAL_CACHE_DIR, exist_ok=True)
    link_name = os.path.basename(fs_path)[: -len(".asset")] + ext
    link_path = os.path.join(LOCAL_CACHE_DIR, link_name)

    current_target = os.readlink(link_path) if os.path.islink(link_path) else None
    if current_target != fs_path:
        if os.path.lexists(link_path):
            os.remove(link_path)
        os.symlink(fs_path, link_path)

    return link_path


# -------------------------
# BUILD file:// URI FROM A DRIVE_ROOT-BASED LOCAL PATH
# -------------------------
def build_file_uri(local_path: str) -> str:
    if local_path.startswith(NEW_CACHE_ROOT):
        # Already a project-local path (steam_cache/external_cache) - no
        # Drive mount translation needed.
        cloud_path = local_path
    else:
        cloud_path = local_path.replace(DRIVE_ROOT, CLOUDSTORAGE_ROOT, 1)

    final_path = resolve_real_path(cloud_path)
    return build_local_file_url(final_path)


STEAM_CACHE_DIR = os.path.join(NEW_CACHE_ROOT, "steam_cache")


# -------------------------
# FIX ALREADY-LOCALIZED file:// URLS POINTING AT WRONGLY-EXTENSIONED FILES
# -------------------------
def collect_extension_fixes(index):
    fixes_by_file = {}

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            link = asset.get("other", {}).get("link")

            if not link or not link.lower().startswith("file:"):
                continue

            fs_path = path_from_file_url(link)
            fname = os.path.basename(fs_path)
            stem = os.path.splitext(fname)[0]

            if os.path.dirname(fs_path) == LOCAL_CACHE_DIR:
                # Re-derive from the original steam_cache file rather than
                # trusting the (possibly missing/stale) local_cache symlink.
                source_path = os.path.join(STEAM_CACHE_DIR, stem + ".asset")
            elif fs_path.lower().endswith(".asset"):
                source_path = fs_path
            else:
                continue

            if not os.path.exists(source_path):
                # The referenced .asset was already renamed away (e.g. a
                # previous --rename-source run). Find the renamed sibling in
                # the same directory instead of silently skipping this link.
                sibling_dir = os.path.dirname(source_path)
                match = next(
                    (
                        f for f in os.listdir(sibling_dir)
                        if os.path.splitext(f)[0] == stem
                    ),
                    None,
                ) if os.path.isdir(sibling_dir) else None

                if not match:
                    continue

                new_url = build_local_file_url(os.path.join(sibling_dir, match))
                if new_url == link:
                    continue

                key = (asset.get("target") or [None])[-1]
                fixes_by_file.setdefault(file_path, []).append((link, new_url, key))
                continue

            new_path = resolve_real_path(source_path)
            if new_path == fs_path:
                continue

            new_url = build_local_file_url(new_path)
            key = (asset.get("target") or [None])[-1]
            fixes_by_file.setdefault(file_path, []).append((link, new_url, key))

    return fixes_by_file


CACHE_ROOT_MOVES = tuple(
    (os.path.join(OLD_CACHE_ROOT, sub), os.path.join(NEW_CACHE_ROOT, sub))
    for sub in ("steam_cache", "external_cache")
)


# -------------------------
# MIGRATE file:// LINKS FROM THE OLD DRIVE-MOUNTED CACHE TO THE NEW
# PROJECT-LOCAL steam_cache/external_cache FOLDERS
# -------------------------
def collect_cache_move_fixes(index):
    fixes_by_file = {}

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            link = asset.get("other", {}).get("link")
            if not link or not link.lower().startswith("file:"):
                continue

            fs_path = path_from_file_url(link)

            for old_root, new_root in CACHE_ROOT_MOVES:
                if fs_path == old_root or fs_path.startswith(old_root + "/"):
                    new_path = new_root + fs_path[len(old_root):]
                    new_url = build_local_file_url(new_path)
                    if new_url != link:
                        key = (asset.get("target") or [None])[-1]
                        fixes_by_file.setdefault(file_path, []).append((link, new_url, key))
                    break

    return fixes_by_file


# -------------------------
# COLLECT PLANNED REPLACEMENTS
# -------------------------
def collect_replacements(index):
    replacements_by_file = {}
    missing = []

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            google = asset.get("google", {})
            link = google.get("link")
            local = google.get("local")

            if not link:
                continue

            if not local:
                missing.append((file_name, asset.get("target"), link))
                continue

            new_url = build_file_uri(local)
            key = (asset.get("target") or [None])[-1]
            replacements_by_file.setdefault(file_path, []).append((link, new_url, key))

    return replacements_by_file, missing


# -------------------------
# APPLY REPLACEMENTS
#
# Each fix is (old_url, new_url) or (old_url, new_url, key), where key is the
# JSON field name (asset["target"][-1]) the value came from, when known. When
# a key is available, the match is scoped to that field's own '"key": "old"'
# text so a value that happens to coincide with a *different* field's value in
# the same file can't get cross-replaced (this silently corrupted
# InvestigatorMat.2822f5.json's "Fonts" CustomUIAsset with its unrelated
# "ImageURL" value, since content.replace() can't tell which field a raw
# string match belongs to). Falls back to the old whole-file replace — with a
# warning — when no key is available or the scoped match isn't unique.
# -------------------------
def apply_replacements(replacements_by_file, apply):
    files_touched = 0
    urls_replaced = 0

    for file_path, replacements in replacements_by_file.items():
        if not os.path.isfile(file_path):
            print(f"SKIP (missing, index.json is stale): {file_path}")
            continue

        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        original = content
        for fix in replacements:
            old_url, new_url, key = fix if len(fix) == 3 else (fix[0], fix[1], None)

            # normalize() unescapes "&" -> "&" for URL classification,
            # but most raw JSON files still contain the escaped form on disk.
            for variant in (old_url, old_url.replace("&", "\\u0026")):
                done = False

                if key:
                    scoped_old = f'"{key}": "{variant}"'
                    if content.count(scoped_old) == 1:
                        content = content.replace(scoped_old, f'"{key}": "{new_url}"')
                        urls_replaced += 1
                        done = True

                if not done and variant in content:
                    occurrences = content.count(variant)
                    if occurrences > 1:
                        print(f"WARNING: '{variant}' appears {occurrences}x in {file_path} "
                              f"and couldn't be scoped to field '{key}' — replacing all occurrences")
                    content = content.replace(variant, new_url)
                    urls_replaced += 1

        if content != original:
            files_touched += 1
            print(f"{'WRITE' if apply else 'PLAN'}: {file_path} ({len(replacements)} url(s))")

            if apply:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content)

    return files_touched, urls_replaced


# -------------------------
# RENAME steam_cache/external_cache FILES TO THEIR REAL EXTENSION
# -------------------------
CACHE_SUBDIRS = ("steam_cache", "external_cache")


def rename_cache_source_files(apply):
    renamed_by_stem = {}
    unknown = []

    for sub in CACHE_SUBDIRS:
        cache_dir = os.path.join(NEW_CACHE_ROOT, sub)
        if not os.path.isdir(cache_dir):
            continue

        for fname in sorted(os.listdir(cache_dir)):
            if not fname.lower().endswith(".asset"):
                continue

            old_path = os.path.join(cache_dir, fname)
            ext = detect_extension(old_path)

            if not ext:
                unknown.append(old_path)
                continue

            stem = fname[: -len(".asset")]
            new_path = os.path.join(cache_dir, stem + ext)

            if os.path.exists(new_path):
                print(f"SKIP (target exists): {new_path}")
                continue

            print(f"{'RENAME' if apply else 'PLAN RENAME'}: {old_path} -> {new_path}")
            if apply:
                os.rename(old_path, new_path)

            renamed_by_stem[stem] = new_path

    return renamed_by_stem, unknown


# -------------------------
# POINT PROJECT file:// LINKS DIRECTLY AT THE RENAMED SOURCE FILES
# -------------------------
def collect_rename_reference_fixes(index, renamed_by_stem):
    fixes_by_file = {}

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            link = asset.get("other", {}).get("link")
            if not link or not link.lower().startswith("file:"):
                continue

            fs_path = path_from_file_url(link)
            stem = os.path.splitext(os.path.basename(fs_path))[0]

            new_cloud_path = renamed_by_stem.get(stem)
            if not new_cloud_path:
                continue

            new_url = build_local_file_url(new_cloud_path)
            if new_url == link:
                continue

            key = (asset.get("target") or [None])[-1]
            fixes_by_file.setdefault(file_path, []).append((link, new_url, key))

    return fixes_by_file


# -------------------------
# RELOCALIZE: rewrite any file:// link with an "assets/..." segment to this
# machine's own checkout, regardless of what absolute prefix/OS it was last
# written with. Run this once after cloning/pulling on a new machine.
# -------------------------
FILE_URL_REGEX = re.compile(r'file:/+[^\s"\']+')


def collect_relocalize_fixes():
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
                subpath = assets_subpath(link)
                if subpath is None:
                    continue

                new_path = os.path.join(ASSETS_ROOT, *subpath.split("/"))
                new_url = build_local_file_url(new_path)
                if new_url != link:
                    fixes_by_file.setdefault(file_path, []).append((link, new_url))

    return fixes_by_file


# -------------------------
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    if "--relocalize" in sys.argv:
        fixes_by_file = collect_relocalize_fixes()
        files_touched, urls_replaced = apply_replacements(fixes_by_file, apply)

        print()
        print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
        print("Files touched:", files_touched)
        print("URLs replaced:", urls_replaced)
        return

    if "--rename-source" in sys.argv:
        index = scan()
        renamed_by_stem, unknown = rename_cache_source_files(apply)
        fixes_by_file = collect_rename_reference_fixes(index, renamed_by_stem)
        files_touched, urls_replaced = apply_replacements(fixes_by_file, apply)

        print()
        print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
        print("Files renamed:", len(renamed_by_stem))
        print("Files touched:", files_touched)
        print("URLs replaced:", urls_replaced)

        if unknown:
            print()
            print("Unrecognized content, left as .asset:", len(unknown))
            for path in unknown:
                print(" ", path)

        return

    index = scan()
    replacements_by_file, missing = collect_replacements(index)
    extension_fixes = collect_extension_fixes(index)
    cache_move_fixes = collect_cache_move_fixes(index)

    for fixes in (extension_fixes, cache_move_fixes):
        for file_path, file_fixes in fixes.items():
            replacements_by_file.setdefault(file_path, []).extend(file_fixes)

    files_touched, urls_replaced = apply_replacements(replacements_by_file, apply)

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Files touched:", files_touched)
    print("URLs replaced:", urls_replaced)

    if missing:
        print()
        print("Missing local files (skipped):", len(missing))
        for file_name, target, link in missing:
            print(f"  {file_name} {target}: {link}")


if __name__ == "__main__":
    main()
