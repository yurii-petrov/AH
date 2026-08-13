#!/usr/bin/env python3
"""Build the EN->UA glossary from the Tabletop Creator card sources.

The TTC projects under `(0) Base Game` keep the Ukrainian text as the default
localization and English under `localization.EN`, so every card field is already
an aligned EN/UA pair. This script harvests the short, term-like fields (types,
traits, locations, investigator names, keyword phrases) and writes a markdown
glossary.

    python3 src/tools/ttc_glossary.py                 # write src/tools/ttc-glossary.md
    python3 src/tools/ttc_glossary.py --root PATH     # other TTC project root
    python3 src/tools/ttc_glossary.py --stdout        # print instead of writing
"""

import argparse
import collections
import json
import os
import re
import sys

DEFAULT_ROOT = os.path.expanduser("~/AH/TTC/(0) Base Game")
DEFAULT_OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ttc-glossary.md")

TAG_RE = re.compile(r"<[^>]+>")
WS_RE = re.compile(r"\s+")
DOOM_RE = re.compile(r"^\{[a-z_]+\}\s*")
DASH_RE = re.compile(r"\s+[-—–]\s+")
CYRILLIC_RE = re.compile(r"[а-яїієґА-ЯЇІЄҐ]")

TYPE_FIELDS = {"type", "type2", "type_001", "b_type", "headline_title"}
PLACE_FIELDS = {
    "sub_title_1", "sub_title_2", "sub_title_3",
    "start_point_desc", "start_point_desc_a", "start_point_desc_b",
}
NAME_FIELDS = {"title", "b_title", "b_name", "f_name", "headline", "name"}
ROLE_FIELDS = {"f_subtitle"}
PHRASE_FIELDS = {"spawn", "move", "info1", "f_focus", "f_ability", "b_lore", "lore"}

MAX_TERM_WORDS = 5
MAX_PHRASE_WORDS = 9


def clean(text):
    return WS_RE.sub(" ", TAG_RE.sub("", text)).strip()


def collect(root):
    """Yield (project, field, ua, en) for every localized field in every set."""
    projects = sorted(
        d for d in os.listdir(root)
        if os.path.isdir(os.path.join(root, d, "data", "sets"))
    )
    if not projects:
        sys.exit("no TTC projects with data/sets under %s" % root)
    for project in projects:
        sets_dir = os.path.join(root, project, "data", "sets")
        for fname in sorted(os.listdir(sets_dir)):
            if not fname.endswith(".json"):
                continue
            path = os.path.join(sets_dir, fname)
            with open(path, encoding="utf-8") as fh:
                data = json.loads(fh.read(), strict=False)
            for field, ua, en in _walk(data):
                yield project, field, ua, en


def _walk(node):
    if isinstance(node, dict):
        if "name" in node and isinstance(node.get("data"), dict):
            ua = node["data"].get("value")
            en = (node.get("localization") or {}).get("EN", {}).get("value")
            if isinstance(ua, str) and isinstance(en, str):
                ua, en = clean(ua), clean(en)
                if ua and en:
                    yield node["name"], ua, en
        for value in node.values():
            for found in _walk(value):
                yield found
    elif isinstance(node, list):
        for value in node:
            for found in _walk(value):
                yield found


def is_term(en, ua):
    if not CYRILLIC_RE.search(ua):
        return False
    if en == ua or en.isdigit():
        return False
    return len(en.split()) <= MAX_TERM_WORDS


def split_traits(en, ua):
    """Split 'Monster - Human Cultist' / 'Монстр - Людина, Культист' into pairs."""
    en_parts = [p.strip() for p in DASH_RE.split(en) if p.strip()]
    ua_parts = [p.strip() for p in DASH_RE.split(ua) if p.strip()]
    if len(en_parts) != len(ua_parts):
        return []
    out = []
    for en_part, ua_part in zip(en_parts, ua_parts):
        en_sub = [p.strip() for p in en_part.split(",") if p.strip()]
        ua_sub = [p.strip() for p in ua_part.split(",") if p.strip()]
        if len(en_sub) == 1 and len(ua_sub) > 1:
            en_sub = en_part.split()
        if len(en_sub) == len(ua_sub):
            out.extend(zip(en_sub, ua_sub))
        else:
            out.append((en_part, ua_part))
    return out


def variables(root):
    path = os.path.join(root, "variables.json")
    if not os.path.exists(path):
        return []
    with open(path, encoding="utf-8") as fh:
        data = json.loads(fh.read(), strict=False)
    out = []
    for var in data.get("variables", []):
        ua = clean(var.get("replacement", ""))
        en = clean((var.get("localization") or {}).get("EN", {}).get("replacement", ""))
        if ua and en:
            out.append((var.get("code", ""), en, ua))
    return sorted(out)


def build(root):
    buckets = {
        "traits": collections.Counter(),
        "types": collections.Counter(),
        "places": collections.Counter(),
        "roles": collections.Counter(),
        "phrases": collections.Counter(),
    }
    names = collections.defaultdict(collections.Counter)
    total = 0

    for project, field, ua, en in collect(root):
        total += 1
        if field in TYPE_FIELDS and is_term(en, ua):
            buckets["types"][(en, ua)] += 1
            for pair in split_traits(en, ua):
                if is_term(*pair):
                    buckets["traits"][pair] += 1
        elif field in PLACE_FIELDS:
            en_p, ua_p = DOOM_RE.sub("", en), DOOM_RE.sub("", ua)
            if is_term(en_p, ua_p):
                buckets["places"][(en_p, ua_p)] += 1
        elif field in ROLE_FIELDS and is_term(en, ua):
            buckets["roles"][(en, ua)] += 1
        elif field in NAME_FIELDS and is_term(en, ua):
            names[project][(en, ua)] += 1
        elif field in PHRASE_FIELDS and CYRILLIC_RE.search(ua) and en != ua:
            if len(en.split()) <= MAX_PHRASE_WORDS:
                buckets["phrases"][(en, ua)] += 1

    return buckets, names, total


def conflicts(buckets, names):
    """EN terms rendered with more than one Ukrainian variant."""
    by_en = collections.defaultdict(collections.Counter)
    for bucket in list(buckets.values()) + list(names.values()):
        for (en, ua), count in bucket.items():
            by_en[en][ua] += count
    return {en: uas for en, uas in by_en.items() if len(uas) > 1}


def table(pairs, header=("English", "Українська", "n")):
    lines = ["| %s | %s | %s |" % header, "| --- | --- | --- |"]
    for (en, ua), count in sorted(pairs.items(), key=lambda kv: kv[0][0].lower()):
        lines.append("| %s | %s | %d |" % (en.replace("|", "\\|"), ua.replace("|", "\\|"), count))
    return "\n".join(lines)


def render(root, buckets, names, total):
    out = [
        "# EN → UA glossary (Tabletop Creator card sources)",
        "",
        "Generated by `src/tools/ttc_glossary.py` from `%s`." % root,
        "Do not edit by hand — rerun the script instead.",
        "",
        "Ukrainian is the default localization in the TTC projects and English lives under",
        "`localization.EN`, so every row below is a real, shipped pair, not a guess.",
        "The `n` column is how many card fields use that pair — higher means more settled",
        "terminology. Where two Ukrainian variants exist for one English term, prefer the",
        "one with the larger `n`.",
        "",
        "Companion file: `.vscode/locales/_glossary.md` covers the UI strings in `uk.po`.",
        "",
        "Source fields scanned: %d localized values across %d projects." % (total, len(names)),
        "",
        "## Traits and keywords",
        "",
        "Atomic components of card type lines (`Monster - Human Cultist` → `Monster`, `Human`, `Cultist`).",
        "",
        table(buckets["traits"]),
        "",
        "## Full type lines",
        "",
        table(buckets["types"]),
        "",
        "## Locations and neighborhoods",
        "",
        table(buckets["places"]),
        "",
        "## Investigator roles",
        "",
        table(buckets["roles"]),
        "",
        "## Recurring rules phrases",
        "",
        table(buckets["phrases"]),
        "",
        "## Text variables",
        "",
        "Shared inline snippets from `variables.json` (formatting tags stripped).",
        "",
        "| Code | English | Українська |",
        "| --- | --- | --- |",
    ]
    for code, en, ua in variables(root):
        out.append("| `%s` | %s | %s |" % (code, en, ua))
    clashes = conflicts(buckets, names)
    out += [
        "",
        "## Terms with more than one Ukrainian variant",
        "",
        "Worth a look — either a deliberate case/context difference or an inconsistency.",
        "",
        "| English | Variants (n) |",
        "| --- | --- |",
    ]
    for en in sorted(clashes, key=str.lower):
        variants = ", ".join(
            "%s (%d)" % (ua, count)
            for ua, count in sorted(clashes[en].items(), key=lambda kv: -kv[1])
        )
        out.append("| %s | %s |" % (en.replace("|", "\\|"), variants.replace("|", "\\|")))
    out += ["", "## Card names by project", ""]
    for project in sorted(names):
        out += ["### %s" % project, "", table(names[project]), ""]
    return "\n".join(out).rstrip() + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--root", default=DEFAULT_ROOT)
    ap.add_argument("--out", default=DEFAULT_OUT)
    ap.add_argument("--stdout", action="store_true")
    args = ap.parse_args()

    root = os.path.abspath(os.path.expanduser(args.root))
    buckets, names, total = build(root)
    text = render(root, buckets, names, total)
    if args.stdout:
        sys.stdout.write(text)
        return
    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write(text)
    counts = ", ".join("%s %d" % (k, len(v)) for k, v in sorted(buckets.items()))
    print("%s: %s, names %d projects, %d source values"
          % (args.out, counts, len(names), total))


if __name__ == "__main__":
    main()
