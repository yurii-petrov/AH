import json
import sys
from pathlib import Path
from slpp import slpp as lua

OUTPUT_DIR = Path("result")

def read(path):
    return Path(path).read_text(encoding="utf-8")


def write(path, content):
    Path(path).write_text(content, encoding="utf-8")


def to_lua(value, indent=0):
    pad = "  " * indent

    if isinstance(value, dict):
        if not value:
            return "{}"

        items = []
        for k, v in value.items():
            items.append(
                f'{pad}  ["{k}"] = {to_lua(v, indent + 1)}'
            )

        return "{\n" + ",\n".join(items) + f"\n{pad}}}"

    if isinstance(value, list):
        if not value:
            return "{}"

        items = [
            f'{pad}  {to_lua(v, indent + 1)}'
            for v in value
        ]

        return "{\n" + ",\n".join(items) + f"\n{pad}}}"

    if isinstance(value, str):
        return f'"{value}"'

    if isinstance(value, bool):
        return "true" if value else "false"

    if value is None:
        return "nil"

    return str(value)


def detect_json(text):
    try:
        json.loads(text)
        return True
    except:
        return False

def get_guid(obj):
    return obj.get("GUID", "unknown")

def process_json(file_path):
    try:
        obj = json.loads(read(file_path))

        memo_raw = obj.get("Memo")
        if not memo_raw:
            print(f"Skip (no Memo): {file_path.name}")
            return

        guid = get_guid(obj)

        memo = json.loads(memo_raw)

        lua_content = "memo=" + to_lua(memo)

        output_file = OUTPUT_DIR / f"{file_path.stem}.lua"
        
        write(output_file, lua_content)

        print(f"JSON → Lua ({guid})")

    except Exception as e:
        print(f"Failed: {file_path.name}")
        print(e)

def strip_memo_prefix(lua_text):
    import re
    return re.sub(r'^\s*[Mm]emo\s*=\s*', '', lua_text).strip()

def minify_lua(lua_text):
    # remove all whitespace that is NOT inside strings
    in_str = False
    quote = None
    result = []

    i = 0
    while i < len(lua_text):
        c = lua_text[i]

        # handle strings
        if c in ['"', "'"]:
            if not in_str:
                in_str = True
                quote = c
            elif quote == c:
                in_str = False
            result.append(c)
            i += 1
            continue

        # if inside string → keep everything
        if in_str:
            result.append(c)
            i += 1
            continue

        # outside string → remove whitespace
        if c.isspace():
            i += 1
            continue

        result.append(c)
        i += 1

    return "".join(result)

def main():
    print("SCRIPT STARTED")

    OUTPUT_DIR.mkdir(exist_ok=True)

    current_dir = Path.cwd()
    project_root = current_dir.parents[2]

    objects_dir = project_root / "AH/objects"

    json_files = sorted(objects_dir.rglob("*.json"))

    print(f"Found {len(json_files)} json file(s)\n")

    for json_file in json_files:
        process_json(json_file)
        
if __name__ == "__main__":
    main()