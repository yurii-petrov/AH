import json
from pathlib import Path
from collections import defaultdict

# =========================================================
# OUTPUT ROOT: inside TTS objects (safe separated folder)
# =========================================================
OUTPUT_DIR = Path(__file__).resolve().parent / "objects"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


# ---------- IO ----------
def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


# ---------- LUA CONVERTER ----------
def to_lua(value, indent=0):
    pad = "  " * indent

    if isinstance(value, dict):
        if not value:
            return "{}"

        items = []
        for k, v in value.items():
            items.append(f'{pad}  ["{k}"] = {to_lua(v, indent + 1)}')

        return "{\n" + ",\n".join(items) + f"\n{pad}}}"

    if isinstance(value, list):
        if not value:
            return "{}"

        items = [f'{pad}  {to_lua(v, indent + 1)}' for v in value]

        return "{\n" + ",\n".join(items) + f"\n{pad}}}"

    if isinstance(value, str):
        return f'"{value}"'

    if isinstance(value, bool):
        return "true" if value else "false"

    if value is None:
        return "nil"

    return str(value)


# ---------- PATH HELPERS ----------
def extract_parts(file_path: Path):
    parts = file_path.parts
    idx = parts.index("objects")
    return parts[idx + 1:-1], file_path.stem


def build_output_path(file_path: Path) -> Path:
    parts = file_path.parts
    idx = parts.index("objects")

    relative = Path(*parts[idx + 1:-1])  # Eng.e75fc8/Deck.xxx
    out_dir = OUTPUT_DIR / relative

    out_dir.mkdir(parents=True, exist_ok=True)

    return out_dir / f"{file_path.stem}.lua"


# ---------- SAFE MEMO PARSER ----------
def safe_parse_memo(memo_raw):
    if isinstance(memo_raw, dict):
        return memo_raw

    if not isinstance(memo_raw, str):
        return None

    s = memo_raw.strip()

    try:
        return json.loads(s)
    except json.JSONDecodeError:
        pass

    try:
        return json.loads(json.loads(s))
    except json.JSONDecodeError:
        return None


# ---------- PROCESS ----------
def process_json(file_path: Path):
    try:
        raw = read(file_path).strip()
        if not raw:
            return None

        obj = json.loads(raw)

        memo_raw = obj.get("Memo")
        if memo_raw is None:
            return None

        memo = safe_parse_memo(memo_raw)
        if memo is None:
            return None

        guid = obj.get("GUID", file_path.stem)

        data = {
            "GUID": guid,
            "memo": memo
        }

        lua_content = "data = " + to_lua(data)

        output_file = build_output_path(file_path)

        write(output_file, lua_content)

        print(f"OK → {output_file.relative_to(OUTPUT_DIR)}")

        return guid

    except Exception as e:
        print(f"FAILED: {file_path.name} -> {e}")
        return None


# ---------- MAIN ----------
def main():
    print("SCRIPT STARTED")

    current_dir = Path.cwd()
    project_root = current_dir.parents[2]
    objects_dir = project_root / "AH/objects"

    print("\n--- PATH DEBUG ---")
    print("objects_dir:", objects_dir)
    print("exists:", objects_dir.exists())
    print("------------------\n")

    json_files = list(objects_dir.rglob("*.json"))

    print(f"Found {len(json_files)} json files\n")

    # optional structure (debug grouping)
    tree = defaultdict(lambda: defaultdict(list))

    for json_file in json_files:
        print("PROCESS:", json_file)

        parts, name = extract_parts(json_file)
        guid = process_json(json_file)

        if not guid:
            continue

        bag = parts[0] if len(parts) > 0 else "root"
        deck = parts[1] if len(parts) > 1 else "single"

        tree[bag][deck].append(name)

    print("\nDONE")


if __name__ == "__main__":
    main()