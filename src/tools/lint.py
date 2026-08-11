#!/usr/bin/env python3
"""Static checks for things TTSModManager builds straight through, then break in game.

    python3 src/tools/lint.py          # report and exit 1 on any error

Checks:
  1. every require("...") resolves to a file under src/
  2. every STEP_HANDLERS value is a function actually defined in src/Global/steps/
  3. every STEP_HANDLERS key is lowercase-alphanumeric (processStep lowercases step.type
     and looks the key up verbatim, so an underscore or capital never matches)
  4. every step file's processStep* handler is global, not `local function`
  5. every processStep* handler is reachable from STEP_HANDLERS
"""
import re
import sys
from pathlib import Path
from typing import List

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "src"
STEPS_FILE = SRC / "Global" / "Steps.ttslua"
STEPS_DIR = SRC / "Global" / "steps"

RE_REQUIRE = re.compile(r'require\(\s*["\']([^"\']+)["\']\s*\)')
RE_HANDLER_ENTRY = re.compile(r"^\s*([A-Za-z0-9_]+)\s*=\s*(processStep[A-Za-z0-9_]*)\s*,", re.M)
RE_GLOBAL_FN = re.compile(r"^function\s+([A-Za-z0-9_]+)\s*\(", re.M)
RE_LOCAL_FN = re.compile(r"^\s*local\s+function\s+(processStep[A-Za-z0-9_]*)\s*\(", re.M)


def lua_sources() -> List[Path]:
    files = sorted(SRC.rglob("*.ttslua"))
    entry = ROOT / "objects" / "LuaScript.ttslua"
    if entry.exists():
        files.append(entry)
    return files


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def check_requires(errors: List[str]) -> None:
    for path in lua_sources():
        text = path.read_text(encoding="utf-8")
        for module in RE_REQUIRE.findall(text):
            target = SRC / (module + ".ttslua")
            if not target.exists():
                line = text[: text.index(module)].count("\n") + 1
                errors.append(
                    f"{rel(path)}:{line}: require(\"{module}\") -> missing {rel(target)}"
                )


def check_steps(errors: List[str]) -> None:
    if not STEPS_FILE.exists():
        errors.append(f"missing {rel(STEPS_FILE)}")
        return

    steps_text = STEPS_FILE.read_text(encoding="utf-8")
    entries = RE_HANDLER_ENTRY.findall(steps_text)
    if not entries:
        errors.append(f"{rel(STEPS_FILE)}: no STEP_HANDLERS entries found — did the format change?")
        return

    defined = {}
    for path in sorted(STEPS_DIR.glob("*.ttslua")):
        text = path.read_text(encoding="utf-8")
        for name in RE_GLOBAL_FN.findall(text):
            if name.startswith("processStep"):
                defined[name] = path
        for name in RE_LOCAL_FN.findall(text):
            errors.append(
                f"{rel(path)}: `local function {name}` is invisible to Steps.ttslua "
                f"— step handlers must be global"
            )

    mapped = set()
    for key, fn in entries:
        mapped.add(fn)
        if fn not in defined:
            errors.append(
                f"{rel(STEPS_FILE)}: STEP_HANDLERS.{key} -> {fn}, which is not defined "
                f"in src/Global/steps/"
            )
        if not key.islower() or not key.isalnum():
            errors.append(
                f"{rel(STEPS_FILE)}: STEP_HANDLERS key '{key}' must be lowercase-alphanumeric "
                f"— processStep looks up string.lower(step.type) verbatim"
            )

    for fn, path in sorted(defined.items(), key=lambda kv: kv[0]):
        if fn not in mapped:
            errors.append(
                f"{rel(path)}: {fn} is defined but has no STEP_HANDLERS entry — "
                f"it will never run"
            )


def main() -> int:
    errors: List[str] = []
    check_requires(errors)
    check_steps(errors)

    if errors:
        print(f"lint: {len(errors)} problem(s)\n")
        for e in errors:
            print(f"  {e}")
        return 1

    print("lint: ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
