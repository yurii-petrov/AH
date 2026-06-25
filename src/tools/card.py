#!/usr/bin/env python3
"""Inspect a TTS object/card JSON without dumping the whole file into context.

Usage:
    python3 src/tools/card.py <GUID|path>      # pretty-print parsed Memo + key fields
    python3 src/tools/card.py <GUID|path> raw  # full JSON, but with Memo expanded

The Memo field in card JSON holds escaped JSON-as-a-string; this expands it so it
is readable. Searching by GUID walks objects/ once and prints the first match.
"""
import json
import sys
from pathlib import Path
from typing import Optional

ROOT = Path(__file__).resolve().parents[2]
OBJECTS = ROOT / "objects"


def find_by_guid(guid: str) -> Optional[Path]:
    needle = guid.lower()
    for p in OBJECTS.rglob("*.json"):
        # filename pattern is <Type>.<guid>.json or NN.<guid>.json
        if needle in p.stem.lower():
            return p
    return None


def expand_memo(d: dict) -> dict:
    out = dict(d)
    memo = out.get("Memo")
    if isinstance(memo, str) and memo.strip().startswith(("{", "[")):
        try:
            out["Memo"] = json.loads(memo)
        except json.JSONDecodeError:
            pass
    return out


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    arg = sys.argv[1]
    raw = len(sys.argv) > 2 and sys.argv[2] == "raw"

    path = Path(arg)
    if not path.exists():
        path = find_by_guid(arg)
        if path is None:
            print(f"No object JSON found for GUID/path: {arg}", file=sys.stderr)
            return 1

    data = json.load(open(path, encoding="utf-8"))
    print(f"# {path.relative_to(ROOT)}")

    if raw:
        print(json.dumps(expand_memo(data), ensure_ascii=False, indent=2))
        return 0

    for k in ("GUID", "Name", "Nickname", "Description"):
        if data.get(k):
            print(f"{k}: {data[k]}")
    memo = data.get("Memo")
    if isinstance(memo, str) and memo.strip().startswith(("{", "[")):
        try:
            print("\nMemo:")
            print(json.dumps(json.loads(memo), ensure_ascii=False, indent=2))
        except json.JSONDecodeError:
            print(f"\nMemo (unparsed): {memo}")
    elif memo:
        print(f"\nMemo: {memo}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
