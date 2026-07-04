import os
import sys

from _po_to_lua_converter import convert_po_to_lua
from _sync_po_files import print_box, sync_and_reorder_files

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
VSCODE_DIR = os.path.dirname(SCRIPT_DIR)
ROOT_DIR = os.path.dirname(VSCODE_DIR)
sys.path.insert(0, VSCODE_DIR)

import build


def main():
    synced = sync_and_reorder_files()
    converted = convert_po_to_lua()

    if not (synced and converted):
        return

    print_box("TRANSLATIONS SYNC SUCCESS")
    build.run_build(ROOT_DIR, "build")


if __name__ == "__main__":
    main()
