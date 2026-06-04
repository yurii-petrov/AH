import re
import json
from pathlib import Path
from slpp import slpp as lua


def strip_memo_prefix(lua_text: str) -> str:
    return re.sub(r'^\s*[Mm]emo\s*=\s*', '', lua_text).strip()


def escape_for_json_string(s: str) -> str:
    return s.replace('\\', '\\\\').replace('"', '\\"')


def update_memo_in_json(json_path: Path, lua_file: Path):
    lua_raw = lua_file.read_text(encoding="utf-8")
    lua_clean = strip_memo_prefix(lua_raw)

    memo_obj = lua.decode(lua_clean)

    # правильний JSON string (як у TTS)
    memo_json = json.dumps(
        memo_obj,
        ensure_ascii=False,
        separators=(",", ":")
    )

    # важливо: escape для JSON FIELD STRING
    memo_json_escaped = escape_for_json_string(memo_json)

    text = json_path.read_text(encoding="utf-8")

    updated_text = re.sub(
        r'("Memo"\s*:\s*")((?:\\.|[^"\\])*)(")',
        lambda m: m.group(1) + memo_json_escaped + m.group(3),
        text
    )

    json_path.write_text(updated_text, encoding="utf-8")

    print(f"Updated Memo → {json_path.name}")


def get_guid(lua_path: Path) -> str:
    return lua_path.stem


def find_object(guid: str, objects_dir: Path):
    return [
        f for f in objects_dir.glob("*.json")
        if f".{guid}." in f.name
    ]


def main():
    current_dir = Path.cwd()
    project_root = current_dir.parents[2]

    objects_dir = project_root / "AH/objects"
    lua_dir = Path("result")

    lua_files = list(lua_dir.glob("*.lua"))

    print(f"Found {len(lua_files)} lua file(s)\n")

    for lua_file in lua_files:
        guid = get_guid(lua_file)
        matches = find_object(guid, objects_dir)

        print(f"[{lua_file.name}] -> GUID: {guid}")

        if not matches:
            print("  ❌ No match\n")
            continue

        for m in matches:
            print(f"  ✅ {m.name}")
            update_memo_in_json(m, lua_file)

        print()


if __name__ == "__main__":
    main()