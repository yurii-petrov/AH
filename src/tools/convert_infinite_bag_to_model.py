import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "drive"))

from asset_index_builder import ROOT_DIR, build_local_file_url, print_box
from assets_manifest import to_absolute_asset

# -------------------------
# Converts a plain "Infinite_Bag.<guid>" (a bare bag, no 3D model) into a
# "Custom_Model_Infinite_Bag.<guid>" (the same bag with the infinite_bag.obj
# model attached), matching the pattern of the already-converted
# Custom_Model_Infinite_Bag.40bae0/.1a067e/.2f7335. Renames the object's
# JSON file + child folder, adds the CustomMesh block, and repoints
# config.json's ObjectStates_order at the new name.
# -------------------------

OBJECTS_DIR = os.path.join(ROOT_DIR, "objects")
CONFIG_FILE = os.path.join(ROOT_DIR, "config.json")

OLD_NAME = "Infinite_Bag"
NEW_NAME = "Custom_Model_Infinite_Bag"

MODEL_URL = build_local_file_url(to_absolute_asset("assets/models/infinite_bag.obj"))

# Identical across every existing Custom_Model_Infinite_Bag.*.json — only
# DiffuseURL (the bag's own icon) differs per instance.
CUSTOM_MESH_TEMPLATE = {
    "CastShadows": True,
    "ColliderURL": MODEL_URL,
    "Convex": True,
    "CustomShader": {
        "FresnelStrength": 0,
        "SpecularColor": {"b": 1, "g": 1, "r": 1},
        "SpecularIntensity": 0,
        "SpecularSharpness": 2,
    },
    "MaterialIndex": 3,
    "MeshURL": MODEL_URL,
    "NormalURL": "",
    "TypeIndex": 7,
}


def find_child_image_url(bag_dir):
    files = [f for f in os.listdir(bag_dir) if f.endswith(".json")]
    if len(files) != 1:
        raise ValueError(f"expected exactly one child json in {bag_dir}, found {len(files)}")

    with open(os.path.join(bag_dir, files[0]), "r", encoding="utf-8") as f:
        child = json.load(f)

    image_url = (child.get("CustomImage") or {}).get("ImageURL")
    if not image_url:
        raise ValueError(f"no CustomImage.ImageURL found in {files[0]}")

    return image_url


def fix_child_path_references(new_dir, guid):
    """A child object's own JSON can carry a self-referencing *_path field
    (e.g. LuaScript_path for one with an attached .ttslua) built from its
    parent's folder name at the time it was written — renaming the parent
    folder moves the file but leaves that stale "Infinite_Bag.<guid>/..."
    string behind, which TTSModManager then fails to find at build time."""
    old_prefix = f"{OLD_NAME}.{guid}/"
    new_prefix = f"{NEW_NAME}.{guid}/"
    fixed = []

    for name in os.listdir(new_dir):
        if not name.endswith(".json"):
            continue
        path = os.path.join(new_dir, name)
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
        if old_prefix not in content:
            continue
        with open(path, "w", encoding="utf-8") as f:
            f.write(content.replace(old_prefix, new_prefix))
        fixed.append(name)

    return fixed


def convert(guid):
    old_json = os.path.join(OBJECTS_DIR, f"{OLD_NAME}.{guid}.json")
    old_dir = os.path.join(OBJECTS_DIR, f"{OLD_NAME}.{guid}")
    new_json = os.path.join(OBJECTS_DIR, f"{NEW_NAME}.{guid}.json")
    new_dir = os.path.join(OBJECTS_DIR, f"{NEW_NAME}.{guid}")

    if not os.path.isfile(old_json):
        print(f"SKIP {guid}: {old_json} not found (already converted?)")
        return False

    with open(old_json, "r", encoding="utf-8") as f:
        data = json.load(f)

    diffuse_url = find_child_image_url(old_dir)

    data["Name"] = NEW_NAME
    data["ContainedObjects_path"] = f"{NEW_NAME}.{guid}"
    custom_mesh = dict(CUSTOM_MESH_TEMPLATE)
    custom_mesh["DiffuseURL"] = diffuse_url
    data["CustomMesh"] = custom_mesh

    with open(new_json, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False, sort_keys=True)
        f.write("\n")
    os.remove(old_json)

    if os.path.isdir(old_dir):
        os.rename(old_dir, new_dir)
        fixed = fix_child_path_references(new_dir, guid)
        for name in fixed:
            print(f"  fixed stale path reference in {name}")

    print(f"Converted {OLD_NAME}.{guid} -> {NEW_NAME}.{guid} (DiffuseURL: {diffuse_url})")
    return True


def update_config_order(converted_guids):
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        content = f.read()

    touched = 0
    for guid in converted_guids:
        old = f'"{OLD_NAME}.{guid}"'
        new = f'"{NEW_NAME}.{guid}"'
        if old in content:
            content = content.replace(old, new)
            touched += 1

    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        f.write(content)

    return touched


def main():
    guids = sys.argv[1:]
    if not guids:
        print("Usage: python3 convert_infinite_bag_to_model.py <guid> [<guid> ...]")
        sys.exit(1)

    converted = [g for g in guids if convert(g)]

    if converted:
        touched = update_config_order(converted)
        print(f"config.json: updated {touched} ObjectStates_order entr{'y' if touched == 1 else 'ies'}")

    print_box(f"CONVERTED {len(converted)}/{len(guids)} INFINITE_BAG(S)")


if __name__ == "__main__":
    main()
