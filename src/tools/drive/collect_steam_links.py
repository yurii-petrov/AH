import json
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import ROOT_DIR, assets_subpath, extract_steam_id, fix_url, normalize, print_box
from assets_manifest import hash_file, to_absolute_asset

STEAM_MANIFEST_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "steam_manifest.json")

# -------------------------
# Run this right after the "Decompose" task (TTSModManager -reverse) has
# pulled a Steam-Cloud-uploaded TTS save back into objects/*.json, replacing
# local file:// links with steamusercontent.com ones. Compares the working
# tree against the given git ref (default HEAD, i.e. the last committed
# local/Drive state) to find exactly those swaps, and records them into
# steam_manifest.json by content hash — so switch_asset_source.py --steam
# can flip to them later, and --local can always flip straight back.
# -------------------------

AGAINST = "HEAD"
for arg in sys.argv[1:]:
    if arg.startswith("--against="):
        AGAINST = arg.split("=", 1)[1]


def changed_object_files(ref):
    out = subprocess.check_output(
        ["git", "diff", "--name-only", ref, "--", "objects/"],
        cwd=ROOT_DIR,
        text=True,
    )
    return [line for line in out.splitlines() if line.endswith(".json")]


def load_old(ref, rel_path):
    try:
        content = subprocess.check_output(["git", "show", f"{ref}:{rel_path}"], cwd=ROOT_DIR, text=True)
    except subprocess.CalledProcessError:
        return None
    try:
        return json.loads(content)
    except json.JSONDecodeError:
        return None


def load_new(rel_path):
    abs_path = os.path.join(ROOT_DIR, rel_path)
    try:
        with open(abs_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError):
        return None


# -------------------------
# Walk two structurally-identical trees in lock-step (Decompose only changes
# leaf string values, not shape) and yield every (old, new) string-leaf pair.
# -------------------------
def walk_pairs(old, new):
    if isinstance(old, dict) and isinstance(new, dict):
        for k, old_v in old.items():
            if k in new:
                yield from walk_pairs(old_v, new[k])
    elif isinstance(old, list) and isinstance(new, list):
        for old_v, new_v in zip(old, new):
            yield from walk_pairs(old_v, new_v)
    elif isinstance(old, str) and isinstance(new, str):
        yield old, new


def load_steam_manifest():
    if not os.path.exists(STEAM_MANIFEST_FILE):
        return {}
    with open(STEAM_MANIFEST_FILE, "r", encoding="utf-8") as f:
        return json.load(f).get("assets", {})


def save_steam_manifest(manifest):
    with open(STEAM_MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump({"assets": manifest}, f, indent=2, ensure_ascii=False, sort_keys=True)


def collect(ref):
    manifest = load_steam_manifest()
    captured = 0
    unresolved = []

    for rel_path in changed_object_files(ref):
        old_data = load_old(ref, rel_path)
        new_data = load_new(rel_path)
        if old_data is None or new_data is None:
            continue

        for old_value, new_value in walk_pairs(old_data, new_data):
            if not old_value.lower().startswith("file:"):
                continue
            if "steamusercontent" not in new_value:
                continue

            subpath = assets_subpath(old_value)
            if not subpath:
                continue

            asset_path = "assets/" + subpath
            abs_path = to_absolute_asset(asset_path)
            if not os.path.isfile(abs_path):
                unresolved.append((rel_path, asset_path))
                continue

            file_hash = hash_file(abs_path)
            new_url = fix_url(normalize(new_value))
            steam_id = extract_steam_id(new_url)

            entry = manifest.setdefault(file_hash, {"paths": {}})
            entry["paths"][asset_path] = {}
            entry["steamId"] = steam_id
            entry["steamUrl"] = new_url
            captured += 1

    save_steam_manifest(manifest)
    return captured, unresolved


def main():
    captured, unresolved = collect(AGAINST)
    print_box(f"STEAM LINKS CAPTURED ({captured})")

    if unresolved:
        print()
        print(f"Could not resolve a local file still on disk for {len(unresolved)} steam link(s):")
        for rel_path, asset_path in unresolved:
            print(f"  {rel_path}: {asset_path}")


if __name__ == "__main__":
    main()
