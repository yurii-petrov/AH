#!/usr/bin/env python3
"""Inspect TTS object/card JSON without dumping whole files into context.

Usage:
    python3 src/tools/card.py <GUID|path>          # pretty-print parsed Memo + key fields
    python3 src/tools/card.py <GUID|path> --raw    # full JSON, but with Memo expanded
    python3 src/tools/card.py --search "text"      # find objects by Nickname/Description/Memo
    python3 src/tools/card.py --deck <GUID|path>   # list the cards inside a deck

The Memo field in card JSON holds escaped JSON-as-a-string; this expands it so it
is readable. --search exists so finding a card never requires grepping objects/,
which is ~3900 files and the main token sink in this repo.
"""
import argparse
import json
import re
import sys
from pathlib import Path
from typing import Iterator, Optional

ROOT = Path(__file__).resolve().parents[2]
OBJECTS = ROOT / "objects"

SEARCH_FIELDS = ("Nickname", "Description", "Memo")


def iter_object_files() -> Iterator[Path]:
    yield from OBJECTS.rglob("*.json")


def find_by_guid(guid: str) -> Optional[Path]:
    needle = guid.lower()
    for p in iter_object_files():
        # filename pattern is <Type>.<guid>.json or NN.<guid>.json
        if needle in p.stem.lower():
            return p
    return None


def find_dir_by_guid(guid: str) -> Optional[Path]:
    needle = guid.lower()
    for p in OBJECTS.rglob("*"):
        if p.is_dir() and needle in p.name.lower():
            return p
    return None


def resolve(arg: str, dirs: bool = False) -> Optional[Path]:
    path = Path(arg)
    if path.exists():
        return path
    if dirs:
        found = find_dir_by_guid(arg)
        if found is not None:
            return found
    return find_by_guid(arg)


def rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(ROOT))
    except ValueError:
        return str(path)


def expand_memo(d: dict) -> dict:
    out = dict(d)
    memo = out.get("Memo")
    if isinstance(memo, str) and memo.strip().startswith(("{", "[")):
        try:
            out["Memo"] = json.loads(memo)
        except json.JSONDecodeError:
            pass
    return out


def load(path: Path) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def snippet(text: str, needle: str, width: int = 70) -> str:
    idx = text.lower().find(needle.lower())
    if idx < 0:
        return ""
    start = max(0, idx - width // 3)
    end = min(len(text), idx + len(needle) + width // 2)
    out = text[start:end].replace("\n", " ")
    out = re.sub(r"\s+", " ", out).strip()
    return ("…" if start > 0 else "") + out + ("…" if end < len(text) else "")


def cmd_search(needle: str, limit: int) -> int:
    lowered = needle.lower()
    found = 0
    scanned = 0

    for path in iter_object_files():
        scanned += 1
        try:
            text = path.read_text(encoding="utf-8")
        except OSError:
            continue
        if lowered not in text.lower():
            continue

        try:
            data = json.loads(text)
        except json.JSONDecodeError:
            continue
        if not isinstance(data, dict):
            continue

        hits = [f for f in SEARCH_FIELDS if lowered in str(data.get(f, "")).lower()]
        if not hits:
            continue

        found += 1
        if found > limit:
            continue

        print(f"{rel(path)}")
        print(f"  GUID: {data.get('GUID', '?')}   Nickname: {data.get('Nickname', '') or '-'}")
        for field in hits:
            print(f"  {field}: {snippet(str(data[field]), needle)}")
        print()

    if found == 0:
        print(f"No object matched {needle!r} (scanned {scanned} files).", file=sys.stderr)
        return 1
    if found > limit:
        print(f"... {found - limit} more match(es); re-run with --limit {found}.")
    print(f"{found} match(es) in {scanned} files.")
    return 0


def cmd_deck(arg: str) -> int:
    path = resolve(arg, dirs=True)
    if path is None:
        print(f"No object found for: {arg}", file=sys.stderr)
        return 1

    folder = path if path.is_dir() else path.with_suffix("")
    if not folder.is_dir():
        data = load(path)
        contained = data.get("ContainedObjects")
        if not contained:
            print(f"{rel(path)} is not a deck (no child folder, no ContainedObjects).",
                  file=sys.stderr)
            return 1
        print(f"# {rel(path)} — {len(contained)} contained object(s)")
        for i, child in enumerate(contained, 1):
            print(f"{i:3}. {child.get('GUID', '?')}  {child.get('Nickname', '') or '-'}")
        return 0

    children = sorted(p for p in folder.glob("*.json"))
    print(f"# {rel(folder)} — {len(children)} card(s)")
    for child in children:
        try:
            data = load(child)
        except (OSError, json.JSONDecodeError):
            print(f"  {child.name}  <unreadable>")
            continue
        print(f"  {child.name:24} {data.get('GUID', '?'):8} {data.get('Nickname', '') or '-'}")
    return 0


def cmd_show(arg: str, raw: bool) -> int:
    path = resolve(arg)
    if path is None:
        print(f"No object JSON found for GUID/path: {arg}", file=sys.stderr)
        return 1

    data = load(path)
    print(f"# {rel(path)}")

    if raw:
        print(json.dumps(expand_memo(data), ensure_ascii=False, indent=2))
        return 0

    for key in ("GUID", "Name", "Nickname", "Description"):
        if data.get(key):
            print(f"{key}: {data[key]}")

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


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="card.py",
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("target", nargs="?", help="GUID or path of an object JSON")
    parser.add_argument("legacy_raw", nargs="?", help=argparse.SUPPRESS)
    parser.add_argument("--raw", action="store_true", help="print the full JSON with Memo expanded")
    parser.add_argument("--search", metavar="TEXT",
                        help="find objects whose Nickname/Description/Memo contains TEXT")
    parser.add_argument("--deck", metavar="GUID|PATH", help="list the cards inside a deck")
    parser.add_argument("--limit", type=int, default=20, help="max search results (default 20)")
    args = parser.parse_args()

    if args.search:
        return cmd_search(args.search, args.limit)
    if args.deck:
        return cmd_deck(args.deck)
    if not args.target:
        parser.print_help()
        return 2
    return cmd_show(args.target, args.raw or args.legacy_raw == "raw")


if __name__ == "__main__":
    raise SystemExit(main())
