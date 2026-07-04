import json
import os
import sys

import openpyxl

# Archived: no longer wired into tasks.json, but kept runnable manually.
# It still lives off the src/tools/ modules/files it always used.
TOOLS_DIR = os.path.normpath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "src", "tools")
)
sys.path.insert(0, TOOLS_DIR)

from asset_index_builder import print_box

XLSX_FILE = os.path.join(TOOLS_DIR, "legacy", "assets_tts_url.xlsx")
INDEX_FILE = os.path.join(TOOLS_DIR, "legacy", "index.json")


# -------------------------
# LOAD "Files" SHEET (path -> downloadLink)
# -------------------------
def load_download_links():
    wb = openpyxl.load_workbook(XLSX_FILE, data_only=True)
    ws = wb["Files"]

    rows = ws.iter_rows(values_only=True)
    next(rows, None)  # skip header

    links = {}
    for path, download_link in rows:
        if path and download_link:
            links[path] = download_link

    return links


# -------------------------
# MAIN
# -------------------------
def main():
    links = load_download_links()

    with open(INDEX_FILE, "r", encoding="utf-8") as f:
        index = json.load(f)

    index.pop("downloads", None)  # old top-level format, superseded by per-asset gUrl

    matched = 0
    for file_data in index["data"].values():
        for asset in file_data.get("assets", []):
            local = asset.get("local")
            if local and local in links:
                asset["gUrl"] = links[local]
                matched += 1

    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

    print_box(f"DOWNLOAD LINKS UPDATED SUCCESS ({matched}/{len(links)} MATCHED)")


if __name__ == "__main__":
    main()
