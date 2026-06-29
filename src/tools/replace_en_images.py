#!/usr/bin/env python3
"""
Replace Ukrainian Google Drive image URLs in Enbag.a24119 JSON files
with their English counterparts from assets_tts_url.xlsx.

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
UKR_MARKERS = {"ukr", "ua"}
EN_MARKERS = {"en", "english"}

DRY_RUN = "--dry-run" in sys.argv


def extract_id(url):
    m = DRIVE_ID_RE.search(url)
    return m.group(1) if m else None


def is_ukr_path(path: str) -> bool:
    lower = path.lower()
    parts = {p.strip().lower() for p in lower.replace("/", " ").split()}
    return bool(parts & UKR_MARKERS)


def is_en_path(path: str) -> bool:
    lower = path.lower()
    parts = {p.strip().lower() for p in lower.replace("/", " ").split()}
    return bool(parts & EN_MARKERS)


def load_excel(xlsx_path: str):
    wb = openpyxl.load_workbook(xlsx_path)
    ws = wb["IMG_result"]
    # id -> (name, tts_url, path)
    by_id = {}
    by_name = {}
    for row in ws.iter_rows(min_row=2, values_only=True):
        name, tts_url, _, _, path = (row[i] if i < len(row) else None for i in range(5))
        if not tts_url or not isinstance(tts_url, str):
            continue
        drive_id = extract_id(tts_url)
        if drive_id:
            by_id[drive_id] = (name or "", tts_url, path or "")
        if name:
            by_name.setdefault(name, []).append((tts_url, path or ""))
    return by_id, by_name


def base_path(path: str) -> str:
    return path.rsplit("/", 1)[0] if "/" in path else path


def find_en_url(name, ukr_path, by_name):
    ukr_base = base_path(ukr_path)
    candidates = by_name.get(name, [])
    for url, path in candidates:
        if is_en_path(path) and base_path(path) == ukr_base:
            en_id = extract_id(url)
            if en_id:
                return "https://drive.google.com/uc?export=view&id=" + en_id
    return None


def replace_urls_in_value(value, by_id, by_name, not_found: set) -> tuple:
    """Returns (new_value, changed: bool)"""
    if not isinstance(value, str) or "drive.google" not in value:
        return value, False
    drive_id = extract_id(value)
    if not drive_id:
        return value, False
    row = by_id.get(drive_id)
    if not row:
        not_found.add(drive_id)
        return value, False
    name, _ukr_url, path = row
    if not is_ukr_path(path):
        return value, False
    en_url = find_en_url(name, path, by_name)
    if not en_url:
        not_found.add(drive_id)
        return value, False
    return en_url, True


def walk_and_replace(obj, by_id, by_name, not_found: set) -> tuple:
    """Recursively walk obj, replace drive URLs. Returns (new_obj, changed)."""
    if isinstance(obj, dict):
        new_dict = {}
        changed = False
        for k, v in obj.items():
            new_v, c = walk_and_replace(v, by_id, by_name, not_found)
            new_dict[k] = new_v
            changed = changed or c
        return new_dict, changed
    elif isinstance(obj, list):
        new_list = []
        changed = False
        for item in obj:
            new_item, c = walk_and_replace(item, by_id, by_name, not_found)
            new_list.append(new_item)
            changed = changed or c
        return new_list, changed
    elif isinstance(obj, str) and "drive.google" in obj:
        return replace_urls_in_value(obj, by_id, by_name, not_found)
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
    by_id, by_name = load_excel(XLSX_PATH)
    print(f"  Loaded {len(by_id)} image entries")

    json_files = sorted(glob.glob(os.path.join(ENBAG_DIR, "**", "*.json"), recursive=True))
    print(f"Found {len(json_files)} JSON files in {ENBAG_DIR}\n")

    not_found = set()
    total_changed = 0

    for path in json_files:
        with open(path, encoding="utf-8") as f:
            data = json.load(f)

        new_data, changed = walk_and_replace(data, by_id, by_name, not_found)

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
            row = by_id.get(drive_id)
            if row:
                name, _, path = row
                print(f"  {drive_id}  ({name!r}, path={path!r})")
            else:
                print(f"  {drive_id}  (not in Excel at all)")


if __name__ == "__main__":
    if DRY_RUN:
        print("=== DRY RUN — no files will be written ===\n")
    process_files()
