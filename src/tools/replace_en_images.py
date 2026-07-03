#!/usr/bin/env python3
"""
Swap /uk/ for /en/ in local asset paths (file:// links under assets/cards,
assets/map_tiles, assets/rules) within a target objects/ folder — for bags
that were duplicated from a Ukrainian-content bag and need to become English.

Usage: python3 src/tools/replace_en_images.py [target_dir] [--apply]

target_dir defaults to objects/Enbag.a24119 if omitted. Pass an absolute path
or one relative to the repo root (e.g. objects/MonstersbyScenarioeng.652031).
"""

import glob
import json
import os
import re
import sys

from asset_index_builder import print_box

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DEFAULT_TARGET = os.path.join(REPO_ROOT, "objects", "Enbag.a24119")

ASSET_URL_RE = re.compile(r'file:/+[^"]*?/assets/(cards|map_tiles|rules)/([^"]*?)/uk/([^"]+)')

APPLY = "--apply" in sys.argv
TARGET_ARGS = [a for a in sys.argv[1:] if not a.startswith("--")]


def resolve_target():
    if not TARGET_ARGS:
        return DEFAULT_TARGET

    arg = TARGET_ARGS[0]
    return arg if os.path.isabs(arg) else os.path.join(REPO_ROOT, arg)


def en_path_exists(category, scenario, filename):
    en_dir = os.path.join(REPO_ROOT, "assets", category, scenario, "en")
    return os.path.isfile(os.path.join(en_dir, filename))


def replace_in_value(value, missing: set) -> tuple:
    if not isinstance(value, str) or "/uk/" not in value or "assets/" not in value:
        return value, False

    def repl(m):
        category, scenario, filename = m.group(1), m.group(2), m.group(3)
        if not en_path_exists(category, scenario, filename):
            missing.add(f"{category}/{scenario}/uk/{filename}")
            return m.group(0)
        return m.group(0).replace(f"/{category}/{scenario}/uk/", f"/{category}/{scenario}/en/")

    new_value = ASSET_URL_RE.sub(repl, value)
    return new_value, new_value != value


def walk_and_replace(obj, missing: set) -> tuple:
    if isinstance(obj, dict):
        new_dict = {}
        changed = False
        for k, v in obj.items():
            new_v, c = walk_and_replace(v, missing)
            new_dict[k] = new_v
            changed = changed or c
        return new_dict, changed
    elif isinstance(obj, list):
        new_list = []
        changed = False
        for item in obj:
            new_item, c = walk_and_replace(item, missing)
            new_list.append(new_item)
            changed = changed or c
        return new_list, changed
    elif isinstance(obj, str):
        return replace_in_value(obj, missing)
    return obj, False


def process_files(target_dir):
    if not os.path.isdir(target_dir):
        print(f"ERROR: target directory not found: {target_dir}")
        sys.exit(1)

    json_files = sorted(glob.glob(os.path.join(target_dir, "**", "*.json"), recursive=True))

    sibling_json = target_dir.rstrip(os.sep) + ".json"
    if os.path.isfile(sibling_json):
        json_files.insert(0, sibling_json)

    print(f"Target: {os.path.relpath(target_dir, REPO_ROOT)}")
    print(f"Found {len(json_files)} JSON file(s)\n")

    missing = set()
    total_changed = 0

    for path in json_files:
        with open(path, encoding="utf-8") as f:
            data = json.load(f)

        new_data, changed = walk_and_replace(data, missing)

        if changed:
            rel = os.path.relpath(path, REPO_ROOT)
            print(f"{'PLAN' if not APPLY else 'WRITE'}: {rel}")
            total_changed += 1
            if APPLY:
                with open(path, "w", encoding="utf-8") as f:
                    json.dump(new_data, f, ensure_ascii=False, indent=2)
                    f.write("\n")

    status = "APPLIED" if APPLY else "DRY RUN"
    print_box(f"EN IMAGES {status} ({total_changed} FILES TOUCHED)")

    if missing:
        print()
        print(f"No 'en' file found for {len(missing)} referenced asset(s), left as uk:")
        for m in sorted(missing):
            print(" ", m)


if __name__ == "__main__":
    process_files(resolve_target())
