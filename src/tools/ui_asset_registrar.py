import json
import os
import re
import sys

from asset_index_builder import (
    ROOT_DIR,
    build_local_file_url,
    extract_google_id,
    load_files_index,
    to_absolute,
)

CUSTOM_UI_ASSETS_PATH = os.path.join(ROOT_DIR, "modsettings", "CustomUIAssets.json")
MODSETTINGS_DIR = os.path.join(ROOT_DIR, "modsettings")

# Steam Cloud upload only scans the mod's static object save-state — it never
# executes Lua and never reads modsettings/*.json. Any local file:// (or raw
# drive.google.com) reference living inside a .ttslua script or a modsettings
# file is therefore invisible to it and never gets uploaded, unless it's
# registered here in CustomUIAssets.json and referenced by Name instead.

# TTS XML UI attributes named "image"/"imageHover" must reference a Name —
# this is TTS's documented mechanism for self.UI.setXmlTable()/setXml() XML.
UI_ATTR_REGEX = re.compile(r'\b(image(?:Hover)?)(\s*=\s*)"(file:[^"]+)"')

# NOTE: bare `return "file:...png"`-style literals feeding a *native* object
# field (CustomImage.ImageURL, MeshURL, ...) passed to spawnObjectData are
# NOT safe to Name-ify — confirmed by Roller.ttslua breaking on save/reload
# when its getDiceImage() returned a Name instead of a real URL. Only the
# CustomUIAssets *registration* (for Steam Cloud discovery) applies there;
# the Lua code itself must keep using a real, resolvable URL.

# self.UI.setCustomAssets({ { name = "x", url = "file:..." }, ... }) is a
# *local*, per-object registration TTS resolves at runtime for its own XML —
# it works in-game but is just as invisible to Steam Cloud as any other Lua
# literal. Migrate each entry to the global registry and delete the call.
SET_CUSTOM_ASSETS_REGEX = re.compile(r'[ \t]*self\.UI\.setCustomAssets\(\s*\{.*?\}\s*\)\n?', re.DOTALL)
SET_CUSTOM_ASSETS_ENTRY_REGEX = re.compile(r'name\s*=\s*"([^"]+)"\s*,\s*url\s*=\s*"([^"]+)"')

TYPE_BY_EXT = {
    ".png": 0, ".jpg": 0, ".jpeg": 0,
    ".unity3d": 1,
    ".mp3": 2, ".wav": 2, ".ogg": 2,
    ".obj": 3, ".fbx": 3,
    ".pdf": 4,
}

TRANSLIT = {
    "а": "a", "б": "b", "в": "v", "г": "h", "ґ": "g", "д": "d", "е": "e", "є": "ie",
    "ж": "zh", "з": "z", "и": "y", "і": "i", "ї": "i", "й": "i", "к": "k", "л": "l",
    "м": "m", "н": "n", "о": "o", "п": "p", "р": "r", "с": "s", "т": "t", "у": "u",
    "ф": "f", "х": "kh", "ц": "ts", "ч": "ch", "ш": "sh", "щ": "shch", "ь": "",
    "ю": "iu", "я": "ia",
}
TRANSLIT.update({k.upper(): v.capitalize() for k, v in TRANSLIT.items() if v})


# -------------------------
# NAME GENERATION
# -------------------------
def transliterate(text: str) -> str:
    return "".join(TRANSLIT.get(ch, ch) for ch in text)


def sanitize_name(url: str) -> str:
    stem = os.path.splitext(os.path.basename(url))[0]
    stem = transliterate(stem)
    stem = re.sub(r"[^a-zA-Z0-9]+", "_", stem).strip("_").lower()
    return stem or "ui_asset"


def guess_type(url: str) -> int:
    ext = os.path.splitext(url)[1].lower()
    return TYPE_BY_EXT.get(ext, 0)


# -------------------------
# CustomUIAssets.json I/O
# -------------------------
def load_custom_ui_assets():
    with open(CUSTOM_UI_ASSETS_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_custom_ui_assets(assets):
    with open(CUSTOM_UI_ASSETS_PATH, "w", encoding="utf-8") as f:
        json.dump(assets, f, indent=2, ensure_ascii=False)


# -------------------------
# SHARED NAME REGISTRY
# -------------------------
class Registry:
    def __init__(self, assets):
        self.assets = assets
        self.url_to_name = {a["URL"]: a["Name"] for a in assets}
        self.existing_names = {a["Name"] for a in assets}
        self.new_assets = []

    def register(self, url):
        name = self.url_to_name.get(url)
        if name:
            return name

        base_name = sanitize_name(url)
        name = base_name
        i = 2
        while name in self.existing_names:
            name = f"{base_name}_{i}"
            i += 1

        self.existing_names.add(name)
        self.url_to_name[url] = name
        entry = {"Name": name, "Type": guess_type(url), "URL": url}
        self.new_assets.append(entry)
        self.assets.append(entry)
        return name


# -------------------------
# RESOLVE A file:// OR raw drive.google.com STRING TO ITS ASSET file:// URL
# -------------------------
def resolve_asset_url(value: str, files_index):
    if value.lower().startswith("file:"):
        return value

    if "drive.google.com" in value:
        gid = extract_google_id(value)
        rel_path = files_index.get(gid) if gid else None
        if rel_path:
            return build_local_file_url(to_absolute(rel_path))

    return None


# -------------------------
# WALK PROJECT FOR .ttslua FILES
# -------------------------
def find_ttslua_files():
    ignore_dirs = {os.path.realpath(os.path.join(ROOT_DIR, ".tts"))}

    def ignored(path):
        path = os.path.realpath(path)
        return any(path.startswith(i) for i in ignore_dirs)

    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if not ignored(os.path.join(root, d))]
        if ignored(root):
            continue

        for file in files:
            if file.endswith(".ttslua"):
                yield os.path.join(root, file)


# -------------------------
# .ttslua FIXES
# -------------------------
RETURN_URL_SCAN_REGEX = re.compile(r'return\s+"(file:[^"]+)"')


def fix_ttslua(content, registry):
    def repl_attr(match):
        attr, eq, url = match.group(1), match.group(2), match.group(3)
        return f'{attr}{eq}"{registry.register(url)}"'

    def repl_set_custom_assets(match):
        for name, url in SET_CUSTOM_ASSETS_ENTRY_REGEX.findall(match.group(0)):
            registry.register(url)  # keep the file's own chosen name where possible
            registry.url_to_name[url] = name
            registry.existing_names.add(name)
            for entry in registry.new_assets:
                if entry["URL"] == url:
                    entry["Name"] = name
        return ""

    content = SET_CUSTOM_ASSETS_REGEX.sub(repl_set_custom_assets, content)
    content = UI_ATTR_REGEX.sub(repl_attr, content)

    # Native-field URLs (return "file://...") get registered for Steam Cloud
    # discovery only — the Lua text itself must keep the real URL, not a Name.
    for url in RETURN_URL_SCAN_REGEX.findall(content):
        registry.register(url)

    return content


# -------------------------
# modsettings/*.json FIXES (excluding CustomUIAssets.json itself)
# -------------------------
def find_modsettings_files():
    for file in sorted(os.listdir(MODSETTINGS_DIR)):
        if file.endswith(".json") and file != "CustomUIAssets.json":
            yield os.path.join(MODSETTINGS_DIR, file)


def fix_modsettings_json(data, registry, files_index):
    if isinstance(data, dict):
        changed = False
        new_data = {}
        for k, v in data.items():
            new_v, c = fix_modsettings_json(v, registry, files_index)
            new_data[k] = new_v
            changed = changed or c
        return new_data, changed

    if isinstance(data, list):
        changed = False
        new_data = []
        for v in data:
            new_v, c = fix_modsettings_json(v, registry, files_index)
            new_data.append(new_v)
            changed = changed or c
        return new_data, changed

    if isinstance(data, str):
        asset_url = resolve_asset_url(data, files_index)
        if asset_url:
            return registry.register(asset_url), True

    return data, False


# -------------------------
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    assets = load_custom_ui_assets()
    registry = Registry(assets)
    files_index = load_files_index()

    ttslua_fixes = {}
    for file_path in find_ttslua_files():
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        new_content = fix_ttslua(content, registry)
        if new_content != content:
            ttslua_fixes[file_path] = new_content

    json_fixes = {}
    for file_path in find_modsettings_files():
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        new_data, changed = fix_modsettings_json(data, registry, files_index)
        if changed:
            json_fixes[file_path] = new_data

    for file_path, content in ttslua_fixes.items():
        print(f"{'WRITE' if apply else 'PLAN'}: {file_path}")
        if apply:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(content)

    for file_path, data in json_fixes.items():
        print(f"{'WRITE' if apply else 'PLAN'}: {file_path}")
        if apply:
            with open(file_path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.write("\n")

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Files touched:", len(ttslua_fixes) + len(json_fixes))
    print("New CustomUIAssets entries:", len(registry.new_assets))
    for a in registry.new_assets:
        print(" ", a["Name"], f"(Type {a['Type']})", "->", a["URL"])

    if apply and registry.new_assets:
        save_custom_ui_assets(assets)


if __name__ == "__main__":
    main()
