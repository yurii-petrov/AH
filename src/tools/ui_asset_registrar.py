import json
import os
import re
import sys

from asset_index_builder import ROOT_DIR

CUSTOM_UI_ASSETS_PATH = os.path.join(ROOT_DIR, "modsettings", "CustomUIAssets.json")

# TTS XML UI attributes named "image"/"imageHover" must reference a Name
# registered in CustomUIAssets.json — unlike native object fields (ImageURL,
# MeshURL, etc.) a raw file:// path doesn't work there. Native-field usages
# (e.g. Roller.ttslua's getDiceImage(), or self.UI.setCustomAssets() url
# tables) are untouched since they don't match this attribute-name pattern.
UI_ATTR_REGEX = re.compile(r'\b(image(?:Hover)?)(\s*=\s*)"(file:[^"]+)"')

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
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    assets = load_custom_ui_assets()
    url_to_name = {a["URL"]: a["Name"] for a in assets}
    existing_names = {a["Name"] for a in assets}
    new_assets = []
    file_fixes = {}

    for file_path in find_ttslua_files():
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        original = content

        def repl(match):
            attr, eq, url = match.group(1), match.group(2), match.group(3)

            name = url_to_name.get(url)
            if not name:
                base_name = sanitize_name(url)
                name = base_name
                i = 2
                while name in existing_names:
                    name = f"{base_name}_{i}"
                    i += 1
                existing_names.add(name)
                url_to_name[url] = name
                new_assets.append({"Name": name, "Type": 0, "URL": url})

            return f'{attr}{eq}"{name}"'

        content = UI_ATTR_REGEX.sub(repl, content)

        if content != original:
            file_fixes[file_path] = content

    for file_path, content in file_fixes.items():
        print(f"{'WRITE' if apply else 'PLAN'}: {file_path}")
        if apply:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(content)

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Files touched:", len(file_fixes))
    print("New CustomUIAssets entries:", len(new_assets))
    for a in new_assets:
        print(" ", a["Name"], "->", a["URL"])

    if apply and new_assets:
        assets.extend(new_assets)
        save_custom_ui_assets(assets)


if __name__ == "__main__":
    main()
