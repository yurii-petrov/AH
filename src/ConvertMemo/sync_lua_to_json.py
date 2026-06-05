import re
import json
from pathlib import Path
from collections import defaultdict
from slpp import slpp as lua


# ---------- PATHS ----------
PROJECT_ROOT = Path.cwd().parents[2]
OBJECTS_DIR = PROJECT_ROOT / "AH" / "objects"
LUA_DIR = PROJECT_ROOT / "AH" / "src" / "ConvertMemo" / "objects"


# ---------- HELPERS ----------
def strip_data_prefix(lua_text: str) -> str:
    return re.sub(r'^\s*data\s*=\s*', '', lua_text).strip()


def escape_for_json_string(s: str) -> str:
    return s.replace('\\', '\\\\').replace('"', '\\"')


# ---------- BUILD INDEX (IMPORTANT SPEED OPTIMIZATION) ----------
def build_json_index(objects_dir: Path):
    index = defaultdict(list)

    for f in objects_dir.rglob("*.json"):
        index[f.stem].append(f)

    return index


# ---------- CORE UPDATE ----------
def update_memo_in_json(json_path: Path, lua_file: Path):
    try:
        lua_raw = lua_file.read_text(encoding="utf-8")
        lua_clean = strip_data_prefix(lua_raw)

        data_obj = lua.decode(lua_clean)
        memo_obj = data_obj.get("memo")

        if memo_obj is None:
            return

        memo_json = json.dumps(
            memo_obj,
            ensure_ascii=False,
            separators=(",", ":")
        )

        memo_json_escaped = escape_for_json_string(memo_json)

        text = json_path.read_text(encoding="utf-8")

        updated_text = re.sub(
            r'("Memo"\s*:\s*")((?:\\.|[^"\\])*)(")',
            lambda m: m.group(1) + memo_json_escaped + m.group(3),
            text
        )

        json_path.write_text(updated_text, encoding="utf-8")

        print(f"Updated → {json_path.name}")

    except Exception as e:
        print(f"FAILED {json_path.name}: {e}")


# ---------- MAIN ----------
def main():
    print("SCRIPT START")

    LUA_DIR.mkdir(parents=True, exist_ok=True)

    lua_files = list(LUA_DIR.rglob("*.lua"))
    print(f"Lua files: {len(lua_files)}")

    print("Indexing JSON files...")
    json_index = build_json_index(OBJECTS_DIR)
    print(f"Indexed keys: {len(json_index)}")

    for lua_file in lua_files:
        name = lua_file.stem

        matches = json_index.get(name, [])

        print(f"[{lua_file.name}] -> {name}")

        if not matches:
            print("  ❌ No match")
            continue

        for json_file in matches:
            update_memo_in_json(json_file, lua_file)

        print()

    print("DONE")


if __name__ == "__main__":
    main()