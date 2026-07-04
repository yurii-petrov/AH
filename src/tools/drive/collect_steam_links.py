import json
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from asset_index_builder import ROOT_DIR, extract_steam_id, fix_url, normalize, print_box
from assets_manifest import load_manifest
from switch_asset_source import build_reverse_maps, load_steam_manifest, resolve_asset_hash

STEAM_MANIFEST_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "steam_manifest.json")

# -------------------------
# Run this right after the "Decompose" task (TTSModManager -reverse) has
# pulled a Steam-Cloud-uploaded TTS save back into the project, replacing
# local/Drive links with steamusercontent.com ones. Compares the working
# tree against the given git ref (default HEAD, i.e. the last committed
# local/Drive state) to find exactly those swaps, and records them into
# steam_manifest.json by content hash — so switch_asset_source.py --steam
# can flip to them later, and --local/--drive can always flip straight back.
#
# The "old" side of a swap is resolved the same way switch_asset_source.py
# resolves any embedded reference (local file:// under assets/, or a Drive
# link) back to its canonical content-hash — reused from there so both
# tools agree on what a given reference means.
# -------------------------

AGAINST = "HEAD"
for arg in sys.argv[1:]:
    if arg.startswith("--against="):
        AGAINST = arg.split("=", 1)[1]


def changed_json_files(ref):
    # -c core.quotePath=false: without it, git C-quotes any non-ASCII path
    # (e.g. a Cyrillic filename becomes "objects/\320\247...json" — note the
    # trailing quote character) and .endswith(".json") below would silently
    # skip every such file.
    out = subprocess.check_output(
        ["git", "-c", "core.quotePath=false", "diff", "--name-only", ref],
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


def save_steam_manifest(manifest):
    with open(STEAM_MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump({"assets": manifest}, f, indent=2, ensure_ascii=False, sort_keys=True)


def collect(ref):
    asset_manifest = load_manifest()
    steam_manifest = load_steam_manifest()
    path_to_hash, drive_id_to_hash, steam_id_to_hash = build_reverse_maps(asset_manifest, steam_manifest)

    captured = 0
    unresolved = []

    for rel_path in changed_json_files(ref):
        old_data = load_old(ref, rel_path)
        new_data = load_new(rel_path)
        if old_data is None or new_data is None:
            continue

        for old_value, new_value in walk_pairs(old_data, new_data):
            if "steamusercontent" not in new_value:
                continue

            file_hash, old_url = resolve_asset_hash(old_value, path_to_hash, drive_id_to_hash, steam_id_to_hash)
            if not file_hash:
                # The pre-Decompose value wasn't a local/Drive link this
                # project's manifests recognize (or matches nothing in
                # them) — nothing to key this Steam link by.
                if old_url:
                    unresolved.append((rel_path, old_url))
                continue

            new_url = fix_url(normalize(new_value))
            steam_id = extract_steam_id(new_url)

            entry = steam_manifest.setdefault(file_hash, {"paths": {}})
            manifest_entry = asset_manifest.get(file_hash)
            if manifest_entry:
                for path in manifest_entry.get("paths", {}):
                    entry["paths"].setdefault(path, {})
            entry["steamId"] = steam_id
            entry["steamUrl"] = new_url
            captured += 1

    save_steam_manifest(steam_manifest)
    return captured, unresolved


def main():
    captured, unresolved = collect(AGAINST)
    print_box(f"STEAM LINKS CAPTURED ({captured})")

    if unresolved:
        print()
        print(f"Could not resolve the pre-Decompose reference for {len(unresolved)} steam link(s):")
        for rel_path, old_url in unresolved:
            print(f"  {rel_path}: {old_url}")


if __name__ == "__main__":
    main()
