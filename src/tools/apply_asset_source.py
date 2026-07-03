import json
import os
import sys

from asset_index_builder import ROOT_DIR, build_local_file_url
from asset_localizer import apply_replacements

INDEX_FILE = os.path.join(os.path.dirname(__file__), "index.json")


# -------------------------
# SWITCH PROJECT REFERENCES BETWEEN THE local FILE, THE gUrl DRIVE LINK, AND
# THE steamUrl STEAM CLOUD LINK, per asset entry recorded in index.json.
# Doesn't rescan the project — run asset_index_builder.py (+
# add_download_links.py for gUrl coverage) first if index.json might be
# stale.
# -------------------------
def collect_fixes(source):
    with open(INDEX_FILE, "r", encoding="utf-8") as f:
        index = json.load(f)["data"]

    fixes_by_file = {}

    for rel_path, file_data in index.items():
        file_path = os.path.join(ROOT_DIR, *rel_path.split("/"))

        for asset in file_data.get("assets", []):
            local = asset.get("local")
            local_url = (
                build_local_file_url(os.path.join(ROOT_DIR, *local.split("/")))
                if local else None
            )

            urls = {
                "local": local_url,
                "drive": asset.get("gUrl"),
                "steam": asset.get("steamUrl"),
            }

            new = urls.get(source)
            if not new:
                continue

            # Scope each replacement to this asset's own JSON field (e.g.
            # "ImageURL" or "URL") so a value that happens to coincide with a
            # *different* field's value in the same file can't get
            # cross-replaced by apply_replacements()'s text-level match.
            key = (asset.get("target") or [None])[-1]

            for other_source, old in urls.items():
                if other_source != source and old:
                    fixes_by_file.setdefault(file_path, []).append((old, new, key))

    return fixes_by_file


# -------------------------
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    if "--local" in sys.argv:
        source = "local"
    elif "--drive" in sys.argv:
        source = "drive"
    elif "--steam" in sys.argv:
        source = "steam"
    else:
        print("Specify --local (use local files), --drive (use Google Drive links), or --steam (use Steam Cloud links)")
        sys.exit(1)

    fixes_by_file = collect_fixes(source)
    files_touched, urls_replaced = apply_replacements(fixes_by_file, apply)

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Source:", source)
    print("Files touched:", files_touched)
    print("URLs replaced:", urls_replaced)


if __name__ == "__main__":
    main()
