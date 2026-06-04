import json
from slpp import slpp as lua
from pathlib import Path


def strip_memo_prefix(lua_text: str) -> str:
    import re
    return re.sub(r'^\s*[Mm]emo\s*=\s*', '', lua_text).strip()


def update_memo_in_json(json_path: Path, lua_file: Path):
    # 1. read lua
    lua_raw = lua_file.read_text(encoding="utf-8")
    lua_clean = strip_memo_prefix(lua_raw)

    # 2. lua -> python obj
    memo_obj = lua.decode(lua_clean)

    # 3. read json object
    obj = json.loads(json_path.read_text(encoding="utf-8"))

    # 4. update memo (stringified like TTS expects)
    obj["Memo"] = json.dumps(
        memo_obj,
        ensure_ascii=False,
        separators=(",", ":")
    )

    # 5. write back
    json_path.write_text(
        json.dumps(obj, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )

    print(f"Updated Memo → {json_path.name}")


def get_guid(lua_path: Path) -> str:
    return lua_path.stem


def find_object(guid: str, objects_dir: Path):
    return [
        f for f in objects_dir.glob("*.json")
        if f".{guid}." in f.name
    ]


def main():
    # поточна папка запуску
    current_dir = Path.cwd()

    # objects завжди в проекті
    project_root = current_dir.parents[2]
    objects_dir = project_root / "AH/objects"
    print(objects_dir)

    lua_dir = Path("result")
    lua_files = list(lua_dir.glob("*.lua"))

    print(f"\nFound {len(lua_files)} lua file(s)\n")

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