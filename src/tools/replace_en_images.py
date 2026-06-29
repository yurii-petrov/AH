#!/usr/bin/env python3
"""
Replace Ukrainian Google Drive image URLs in Enbag.a24119 JSON files
with their English counterparts from assets_tts_url.xlsx (Lang_Compare sheet).

Usage: python3 src/tools/replace_en_images.py [--dry-run]
"""

import json
import glob
import re
import sys
import os
import shutil
import subprocess

try:
    import openpyxl
except ImportError:
    print("openpyxl not found, installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "openpyxl"])
    import openpyxl

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENBAG_DIR = os.path.join(REPO_ROOT, "objects", "Enbag.a24119")
UKBAG_DIR = os.path.join(REPO_ROOT, "objects", "Ukbag.69279c")
XLSX_PATH = os.path.join(REPO_ROOT, "src", "tools", "assets_tts_url.xlsx")

DRIVE_ID_RE = re.compile(r"[?&]id=([A-Za-z0-9_\-]+)")

DRY_RUN = "--dry-run" in sys.argv


def extract_id(url):
    m = DRIVE_ID_RE.search(url)
    return m.group(1) if m else None


def load_excel(xlsx_path: str) -> dict:
    wb = openpyxl.load_workbook(xlsx_path)
    ws = wb["Lang_Compare"]
    headers = [ws.cell(1, i + 1).value for i in range(ws.max_column)]
    print(f"  Lang_Compare columns: {headers}")
    print(f"  Total rows: {ws.max_row - 1}")
    # columns: Name, Path, UK ID, ENG ID
    uk_to_en = {}
    missing_en = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        name, path, uk_id, eng_id = (row[i] if i < len(row) else None for i in range(4))
        if not uk_id:
            continue
        uk_id = str(uk_id).strip()
        if not eng_id or not str(eng_id).strip():
            missing_en.append((name, path, uk_id))
            continue
        uk_to_en[uk_id] = str(eng_id).strip()
    if missing_en:
        print(f"  WARNING: {len(missing_en)} rows have UK ID but no ENG ID:")
        for name, path, uid in missing_en:
            print(f"    {name!r}  path={path!r}  uk={uid}")
    return uk_to_en


def replace_urls_in_value(value, uk_to_en, not_found: set) -> tuple:
    if not isinstance(value, str) or "drive.google" not in value:
        return value, False
    drive_id = extract_id(value)
    if not drive_id:
        return value, False
    en_id = uk_to_en.get(drive_id)
    if not en_id:
        not_found.add(drive_id)
        normalized = "https://drive.google.com/uc?export=download&id=" + drive_id
        return normalized, normalized != value
    return "https://drive.google.com/uc?export=download&id=" + en_id, True


def walk_and_replace(obj, uk_to_en, not_found: set) -> tuple:
    if isinstance(obj, dict):
        new_dict = {}
        changed = False
        for k, v in obj.items():
            new_v, c = walk_and_replace(v, uk_to_en, not_found)
            new_dict[k] = new_v
            changed = changed or c
        return new_dict, changed
    elif isinstance(obj, list):
        new_list = []
        changed = False
        for item in obj:
            new_item, c = walk_and_replace(item, uk_to_en, not_found)
            new_list.append(new_item)
            changed = changed or c
        return new_list, changed
    elif isinstance(obj, str) and "drive.google" in obj:
        return replace_urls_in_value(obj, uk_to_en, not_found)
    return obj, False


def reset_enbag():
    print(f"Clearing {ENBAG_DIR} ...")
    for item in os.listdir(ENBAG_DIR):
        item_path = os.path.join(ENBAG_DIR, item)
        if os.path.isdir(item_path):
            shutil.rmtree(item_path)
        else:
            os.remove(item_path)
    print(f"Copying from {UKBAG_DIR} ...")
    for item in os.listdir(UKBAG_DIR):
        src = os.path.join(UKBAG_DIR, item)
        dst = os.path.join(ENBAG_DIR, item)
        if os.path.isdir(src):
            shutil.copytree(src, dst)
        else:
            shutil.copy2(src, dst)
    print("Done.\n")


def process_files():
    if not os.path.exists(XLSX_PATH):
        print("ERROR: assets_tts_url.xlsx not found.")
        print("Please add assets_tts_url.xlsx to src/tools/")
        sys.exit(1)
    if not DRY_RUN:
        reset_enbag()
    print(f"Loading Excel: {XLSX_PATH}")
    uk_to_en = load_excel(XLSX_PATH)
    print(f"  Loaded {len(uk_to_en)} UK→EN image mappings")

    json_files = sorted(glob.glob(os.path.join(ENBAG_DIR, "**", "*.json"), recursive=True))
    print(f"Found {len(json_files)} JSON files in {ENBAG_DIR}\n")

    not_found = set()
    total_changed = 0

    for path in json_files:
        with open(path, encoding="utf-8") as f:
            data = json.load(f)

        new_data, changed = walk_and_replace(data, uk_to_en, not_found)

        if changed:
            rel = os.path.relpath(path, REPO_ROOT)
            print(f"  {'[DRY RUN] ' if DRY_RUN else ''}Updated: {rel}")
            total_changed += 1
            if not DRY_RUN:
                with open(path, "w", encoding="utf-8") as f:
                    json.dump(new_data, f, ensure_ascii=False, indent=2)
                    f.write("\n")

    print(f"\nFiles updated: {total_changed}")
    if not_found:
        print(f"\nIDs with no EN replacement found ({len(not_found)}):")
        for drive_id in sorted(not_found):
            print(f"  {drive_id}")


if __name__ == "__main__":
    if DRY_RUN:
        print("=== DRY RUN — no files will be written ===\n")
    process_files()
