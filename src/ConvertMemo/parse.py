import json
import sys
from pathlib import Path
from slpp import slpp as lua

OUTPUT_DIR = Path("result")
RESULT_JSON = "result.json"
RESULT_LUA = "result.lua"


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
    obj = json.loads(read(file_path))

    guid = get_guid(obj)

    memo = json.loads(obj["Memo"])

    lua = "memo=" + to_lua(memo)

    output_file = OUTPUT_DIR / f"{guid}.lua"
    write(output_file, lua)
    print(f"JSON → Lua ({guid})")

def process_lua(file_path):
    lua_raw = read(file_path)

    lua_clean = strip_memo_prefix(lua_raw)

    memo_obj = lua.decode(lua_clean)

    memo_str = json.dumps(
        memo_obj,
        ensure_ascii=False,
        separators=(",", ":")  # optional minify
    )

    obj = {
        "Memo": memo_str
    }

    write(RESULT_JSON, json.dumps(obj, indent=2, ensure_ascii=False))
    print("Lua → JSON (Memo only)")

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
    file_path = sys.argv[1]
    raw = read(file_path)

    if detect_json(raw):
        process_json(file_path)
    else:
        process_lua(file_path)


if __name__ == "__main__":
    main()