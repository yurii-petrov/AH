import os
import re
import json
import openpyxl

ROOT_DIR = "/Users/yurii/AH/TTS/AH"
OUTPUT_FILE = "/Users/yurii/AH/assets_dump/index.json"
TTS_INDEX_XLSX = os.path.join(os.path.dirname(__file__), "assets_tts_url.xlsx")
DRIVE_ROOT = "/Users/yurii/My Drive/Arkham Horror (TTS)"

URL_REGEX = re.compile(r'https?://[^\s"\']+')


# -------------------------
# NORMALIZE
# -------------------------
def normalize(text: str) -> str:
    return (
        text.replace("\\u0026", "&")
            .replace("\\/", "/")
    )


# -------------------------
# FIX URLS
# -------------------------
def fix_url(url: str) -> str:
    return (
        url.replace("httpssteam", "https://steam")
           .replace("httpsteam", "http://steam")
           .replace("httpscloud", "https://cloud")
           .replace("httpcloud", "http://cloud")
           .replace("httpssteamusercontent", "https://steamusercontent")
           .replace("httpsteamusercontent", "http://steamusercontent")
    )


# -------------------------
# FILE EXT
# -------------------------
def get_file_name(path: str) -> str:
    return os.path.basename(path)


# -------------------------
# SOURCE DETECTION
# -------------------------
def classify(url: str):
    if "drive.google.com" in url:
        return "google"
    if "steamusercontent" in url:
        return "steam"
    return "other"


# -------------------------
# ID EXTRACTORS
# -------------------------
def extract_google_id(url: str):
    import re
    m = re.search(r"/d/([a-zA-Z0-9_-]+)", url)
    if m:
        return m.group(1)

    m = re.search(r"[?&]id=([a-zA-Z0-9_-]+)", url)
    if m:
        return m.group(1)

    return None


def extract_steam_id(url: str):
    import re
    m = re.search(r"ugc/([0-9]+)", url)
    if m:
        return m.group(1)

    nums = re.findall(r"([0-9]{8,})", url)
    return nums[-1] if nums else None


# -------------------------
# LOAD TTS_INDEX SHEET (id -> name, drivePath)
# -------------------------
def load_tts_index():
    if not os.path.exists(TTS_INDEX_XLSX):
        return {}

    wb = openpyxl.load_workbook(TTS_INDEX_XLSX, data_only=True)
    ws = wb["TTS_Index"]

    lookup = {}
    rows = ws.iter_rows(values_only=True)
    next(rows, None)  # skip header

    for row_id, name, drive_path, url in rows:
        if row_id:
            lookup[row_id] = {"name": name, "drivePath": drive_path}

    return lookup


# -------------------------
# LOAD LOCAL DRIVE FILES (drivePath -> {stem: full_path})
# -------------------------
def load_local_files():
    if not os.path.isdir(DRIVE_ROOT):
        return {}

    drive_parent = os.path.dirname(DRIVE_ROOT)
    local_files = {}

    for dirpath, _, files in os.walk(DRIVE_ROOT):
        drive_path = os.path.relpath(dirpath, drive_parent)
        stems = {}

        for f in files:
            full_path = os.path.join(dirpath, f)
            stem, _ = os.path.splitext(f)
            stems[stem] = full_path
            stems[f] = full_path

        local_files[drive_path] = stems

    return local_files


def fill_local_path(asset_google, local_files):
    drive_path = asset_google.get("drivePath")
    name = asset_google.get("name")

    if not drive_path or not name:
        return

    asset_google["local"] = local_files.get(drive_path, {}).get(name)


# -------------------------
# LOAD EXISTING INDEX (MERGE SUPPORT)
# -------------------------
def load_index():
    if not os.path.exists(OUTPUT_FILE):
        return {}

    try:
        with open(OUTPUT_FILE, "r", encoding="utf-8") as f:
            return json.load(f).get("data", {})
    except:
        return {}


# -------------------------
# SCHEMA FIX (NEW)
# -------------------------
def ensure_schema(index):
    for file_data in index.values():
        for asset in file_data.get("assets", []):
            if "google" in asset:
                asset["google"].setdefault("drivePath", None)
    return index


# -------------------------
# ADD / MERGE ASSET
# -------------------------
def fill_google_metadata(asset_google, tts_index):
    info = tts_index.get(asset_google["id"])
    if info:
        asset_google["name"] = info["name"]
        asset_google["drivePath"] = info["drivePath"]


def add_asset(index, file_name, file_path, source, url, target, tts_index, local_files):
    if file_name not in index:
        index[file_name] = {
            "path": file_path,
            "assets": []
        }

    assets = index[file_name]["assets"]

    # find existing by target
    for asset in assets:
        if asset["target"] == target:
            asset[source]["link"] = url

            if source == "google":
                asset[source].setdefault("drivePath", None)
                asset[source]["id"] = extract_google_id(url)
                fill_google_metadata(asset[source], tts_index)
                fill_local_path(asset[source], local_files)

            if source == "steam":
                asset[source]["id"] = extract_steam_id(url)

            return

    # create new asset
    new_asset = {
        "target": target,

        "google": {
            "id": None,
            "name": None,
            "link": None,
            "local": None,
            "drivePath": None
        },

        "steam": {
            "id": None,
            "name": None,
            "link": None,
            "local": None
        },

        "other": {
            "link": None
        }
    }

    new_asset[source]["link"] = url

    if source == "google":
        new_asset[source]["id"] = extract_google_id(url)
        fill_google_metadata(new_asset[source], tts_index)
        fill_local_path(new_asset[source], local_files)

    elif source == "steam":
        new_asset[source]["id"] = extract_steam_id(url)

    assets.append(new_asset)


# -------------------------
# JSON WALKER
# -------------------------
def walk(obj, file_name, file_path, index, tts_index, local_files, path=None):
    if path is None:
        path = []

    if isinstance(obj, dict):
        for k, v in obj.items():
            walk(v, file_name, file_path, index, tts_index, local_files, path + [k])

    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            walk(v, file_name, file_path, index, tts_index, local_files, path + [i])

    elif isinstance(obj, str):
        if "http" not in obj:
            return

        url = fix_url(normalize(obj))
        source = classify(url)

        add_asset(
            index,
            file_name,
            file_path,
            source,
            url,
            path,
            tts_index,
            local_files
        )


# -------------------------
# SCAN PROJECT
# -------------------------
def scan():
    index = ensure_schema(load_index())
    tts_index = load_tts_index()
    local_files = load_local_files()

    IGNORE_DIRS = {
        os.path.realpath(os.path.join(ROOT_DIR, ".tts")),
        os.path.realpath(os.path.join(ROOT_DIR, "src/tools")),
    }

    def ignored(path):
        path = os.path.realpath(path)
        return any(path.startswith(i) for i in IGNORE_DIRS)

    for root, dirs, files in os.walk(ROOT_DIR):

        dirs[:] = [
            d for d in dirs
            if not ignored(os.path.join(root, d))
        ]

        if ignored(root):
            continue

        for file in files:
            if not file.endswith((".json", ".lua", ".xml", ".txt")):
                continue

            file_path = os.path.join(root, file)
            file_name = file

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = json.load(f)
            except:
                continue

            walk(content, file_name, file_path, index, tts_index, local_files)

    return index


# -------------------------
# MAIN
# -------------------------
def main():
    index = scan()

    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)

    output = {
        "data": index
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print("DONE")
    print("Files:", len(index))


if __name__ == "__main__":
    main()