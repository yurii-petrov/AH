import json

# файл з твоїм JSON
INPUT_FILE = "CustomUIAssets.json"

# результат
OUTPUT_FILE = "assets.lua"


def to_lua(value, indent=0):
    space = "    " * indent

    if isinstance(value, dict):
        result = "{\n"
        for k, v in value.items():
            result += f'{space}    ["{k}"] = {to_lua(v, indent + 1)},\n'
        result += space + "}"
        return result

    if isinstance(value, list):
        result = "{\n"
        for item in value:
            result += f"{space}    {to_lua(item, indent + 1)},\n"
        result += space + "}"
        return result

    if isinstance(value, str):
        return f'"{value}"'

    if isinstance(value, bool):
        return "true" if value else "false"

    if value is None:
        return "nil"

    return str(value)


with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)


lua = "assets = " + to_lua(data) + "\n"


with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write(lua)


print(f"Done: {OUTPUT_FILE}")