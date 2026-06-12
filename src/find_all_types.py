import os
import re
from pathlib import Path

TYPE_PATTERN = re.compile(
    r'\[\s*["\']type["\']\s*\]\s*=\s*["\']([^"\']+)["\']'
)

def extract_types_from_file(file_path: Path):
    types = set()

    try:
        content = file_path.read_text(encoding="utf-8", errors="ignore")
        matches = TYPE_PATTERN.findall(content)
        types.update(matches)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")

    return types


def scan_directory(root_dir: str):
    root = Path(root_dir)
    all_types = set()

    for file_path in root.rglob("*.lua"):
        print("FILE:", file_path)
        file_types = extract_types_from_file(file_path)
        all_types.update(file_types)

    return sorted(all_types)


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python extract_lua_types.py <folder_path>")
        exit(1)

    folder = sys.argv[1]
    result = scan_directory(folder)

    print("\nUnique types found:\n")
    for t in result:
        print("-", t)

    print(f"\nTotal: {len(result)}")