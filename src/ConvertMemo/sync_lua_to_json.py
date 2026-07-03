import re
import json
from pathlib import Path
from slpp import slpp as lua


# ---------- PATHS ----------
PROJECT_ROOT = Path.cwd().parents[2]
OBJECTS_DIR = PROJECT_ROOT / "AH" / "objects"
LUA_DIR = PROJECT_ROOT / "AH" / "src" / "ConvertMemo" / "objects"


def print_box(message):
    pad = 5
    width = len(message) + pad * 2
    print()
    print("╔" + "═" * width + "╗")
    print("║" + " " * pad + message + " " * pad + "║")
    print("╚" + "═" * width + "╝")
    print()


# ---------- HELPERS ----------
def strip_data_prefix(lua_text: str) -> str:
    return re.sub(r'^\s*data\s*=\s*', '', lua_text).strip()


def escape_for_json_string(s: str) -> str:
    return s.replace('\\', '\\\\').replace('"', '\\"')


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

    for lua_file in lua_files:
        rel = lua_file.relative_to(LUA_DIR)
        json_file = OBJECTS_DIR / rel.with_suffix(".json")

        print(f"[{lua_file.name}] -> {json_file.relative_to(OBJECTS_DIR)}")

        if not json_file.exists():
            print("  ❌ No match")
            continue

        update_memo_in_json(json_file, lua_file)
        print()

    print_box(f"LUA -> JSON SYNC SUCCESS ({len(lua_files)} FILES)")


if __name__ == "__main__":
    main()