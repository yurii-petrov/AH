#!/usr/bin/env python3
"""
Walk objects/Ukbag.69279c and objects/MonstersbyScenariouk.dd5297, and for every
JSON object whose top-level "Nickname" is non-Cyrillic and non-empty, look up a
Ukrainian translation in locales/uk.po (msgid = Nickname with spaces replaced by
underscores) and replace the Nickname in place if a translation is found.
"""

import json
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PO_PATH = os.path.join(REPO_ROOT, "locales", "uk.po")
TARGET_DIRS = [
    os.path.join(REPO_ROOT, "objects", "Ukbag.69279c"),
    os.path.join(REPO_ROOT, "objects", "MonstersbyScenariouk.dd5297"),
]

CYRILLIC_RE = re.compile(r"[Ѐ-ӿ]")


def parse_po(path):
    """Return dict msgid -> msgstr for simple (non-plural, single/multi-line) entries."""
    translations = {}
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    i = 0

    def parse_string_block(start):
        """lines[start] begins with 'msgid \"...\"' or 'msgstr \"...\"'; consume
        continuation lines that are bare quoted strings."""
        line = lines[start].strip()
        _, _, rest = line.partition(" ")
        parts = [decode_po_string(rest)]
        j = start + 1
        while j < len(lines) and lines[j].strip().startswith('"'):
            parts.append(decode_po_string(lines[j].strip()))
            j += 1
        return "".join(parts), j

    def decode_po_string(s):
        s = s.strip()
        if s.startswith('"') and s.endswith('"'):
            s = s[1:-1]
        return s.replace('\\n', '\n').replace('\\"', '"').replace('\\\\', '\\')

    while i < len(lines):
        line = lines[i].strip()
        if line.startswith("msgid "):
            msgid, i = parse_string_block(i)
            if i < len(lines) and lines[i].strip().startswith("msgstr "):
                msgstr, i = parse_string_block(i)
                if msgid:
                    translations[msgid] = msgstr
            continue
        i += 1

    return translations


def iter_json_files(root):
    for dirpath, _dirnames, filenames in os.walk(root):
        for name in filenames:
            if name.endswith(".json"):
                yield os.path.join(dirpath, name)


def main():
    translations = parse_po(PO_PATH)

    changed = 0
    checked = 0

    for target_dir in TARGET_DIRS:
        for path in iter_json_files(target_dir):
            checked += 1
            with open(path, "r", encoding="utf-8") as f:
                try:
                    data = json.load(f)
                except json.JSONDecodeError:
                    print(f"SKIP (invalid json): {path}", file=sys.stderr)
                    continue

            if not isinstance(data, dict) or "Nickname" not in data:
                continue

            nickname = data["Nickname"]
            if not isinstance(nickname, str) or not nickname:
                continue
            if CYRILLIC_RE.search(nickname):
                continue

            msgid = nickname.replace(" ", "_")
            translation = translations.get(msgid)
            if not translation:
                continue

            data["Nickname"] = translation
            with open(path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.write("\n")

            changed += 1
            print(f"{path}: '{nickname}' -> '{translation}'")

    print(f"\nChecked {checked} files, changed {changed}.")


if __name__ == "__main__":
    main()
