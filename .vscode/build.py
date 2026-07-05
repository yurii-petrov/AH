# Standard Library
import argparse
import datetime
import json
import os
import platform
import shutil
import subprocess
import time
from pathlib import Path

# Third-Party Libraries
try:
    import pyautogui
except ImportError:
    pyautogui = None

try:
    import pygetwindow
except ImportError:
    pygetwindow = None

PLATFORM = platform.system()
TTS_SUFFIX = Path("Tabletop Simulator") / "Saves"


def print_box(message):
    pad = 5
    width = len(message) + pad * 2
    print()
    print("╔" + "═" * width + "╗")
    print("║" + " " * pad + message + " " * pad + "║")
    print("╚" + "═" * width + "╝")
    print()

# Helper Functions


def load_config():
    """Loads configuration from build_config.json with defaults."""
    config_path = Path(__file__).parent / "build_config.json"
    data = {"GAME_NAME": "ArkhamSCE", "HOTKEY": "f13"}  # Defaults

    if config_path.is_file():
        try:
            with open(config_path, "r") as f:
                user_config = json.load(f)
                data.update(user_config)
        except Exception as e:
            print(f"Warning: Could not read build_config.json ({e}). Using defaults.")
    return data


def get_current_git_branch():
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None


def get_windows_documents_dir() -> Path:
    """Helper to safely retrieve the Windows Documents folder via registry."""
    try:
        import winreg

        sub_key = (
            r"Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
        )
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, sub_key) as key:
            # 'Personal' is the registry key for the Documents folder
            doc_path_str, _ = winreg.QueryValueEx(key, "Personal")

            # Expand environment variables like %USERPROFILE% if present
            return Path(os.path.expandvars(doc_path_str))
    except Exception:
        # Fallback to standard guess if registry lookup fails
        return Path.home() / "Documents"


def get_output_folder():
    if PLATFORM == "Windows":
        base_dir = get_windows_documents_dir() / "My Games"
    elif PLATFORM == "Darwin":  # macOS
        base_dir = Path.home() / "Library"
    else:  # Linux
        base_dir = Path.home() / ".local" / "share"

    return base_dir / TTS_SUFFIX


def get_base_command():
    binary_map = {
        "Windows": "TTSModManager.exe",
        "Darwin": "TTSModManager-macOS",
        "Linux": "TTSModManager",
    }
    binary_name = binary_map.get(PLATFORM, "TTSModManager")
    binary_path = Path(__file__).parent / "bin" / binary_name

    if not binary_path.is_file():
        raise FileNotFoundError(f"TTSModManager binary not found at {binary_path}")

    return [str(binary_path)]


def load_savegame_in_TTS():
    """Attempts to focus TTS and send the hotkey for loading."""
    if PLATFORM == "Windows":
        # Check if the required Windows libraries are available
        if pygetwindow is None or pyautogui is None:
            print(
                "Info: 'pygetwindow' or 'pyautogui' not installed. Cannot automatically load the savegame in TTS."
            )
            return

        for window in pygetwindow.getWindowsWithTitle(WINDOW_TITLE):
            # Check if the title is an EXACT match
            if window.title == WINDOW_TITLE:
                try:
                    window.activate()
                except pygetwindow.PyGetWindowException:
                    # If direct activation fails, toggle the window state
                    # This bypasses the Windows focus restriction
                    window.minimize()
                    window.restore()

                time.sleep(0.5)  # Give the OS time to switch focus

                # Requires setup in TTS (Example Autoexec.cfg: bind f13 load ArkhamSCE)
                pyautogui.hotkey(HOTKEY)
                break  # Found the exact window, so stop searching

    elif PLATFORM == "Darwin":
        # TODO
        return

    elif PLATFORM == "Linux":
        # TODO
        return


def copy_preview_image(output_folder, branch):
    base_image = Path(f"{GAME_NAME}.png")
    dev_image = Path(f"{GAME_NAME}_dev.png")

    # Use dev image ONLY if on a non-main branch AND the file exists
    if branch and branch != "main" and dev_image.exists():
        source_image = dev_image
    else:
        source_image = base_image

    # Perform the copy (and maybe rename) with a safety check
    if source_image.exists():
        shutil.copy(source_image, output_folder / base_image)
    else:
        print(f"Note: Icon {source_image} not found, skipping copy.")


def unescape_html_entities(moddir):
    """TTSModManager's Go JSON encoder HTML-escapes &, <, > as \\u0026/\\u003c/\\u003e
    in decomposed JSON (Go's encoding/json default). Undo that so diffs stay clean."""
    replacements = (("\\u0026", "&"), ("\\u003c", "<"), ("\\u003e", ">"))
    skip_dirs = {".git", ".venv", "node_modules"}

    for root, dirs, files in os.walk(moddir):
        dirs[:] = [d for d in dirs if d not in skip_dirs]
        for name in files:
            if not name.endswith(".json"):
                continue
            path = Path(root) / name
            text = path.read_text(encoding="utf-8")
            new_text = text
            for escaped, literal in replacements:
                new_text = new_text.replace(escaped, literal)
            if new_text != text:
                path.write_text(new_text, encoding="utf-8")


# CONFIGURATION
CONFIG = load_config()
GAME_NAME = CONFIG["GAME_NAME"]
HOTKEY = CONFIG["HOTKEY"]
WINDOW_TITLE = "Tabletop Simulator"


# Main Logic
def run_build(moddir, action):
    """Runs the TTSModManager build/decompose step — the one thing other
    scripts (sync_assets_to_drive.py, sync_translations.py) need to trigger
    without going through argv, so they can end with an up-to-date mod file
    instead of leaving that as a separate manual step for the user."""
    start_time = time.time()
    start_time_formatted = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    output_folder = get_output_folder()
    cmd = get_base_command()

    mod_dir_arg = ["-moddir", moddir]
    mod_file_arg = ["-modfile", str(output_folder / f"{GAME_NAME}.json")]
    reverse_arg = ["-reverse"] if action == "decompose" else []

    full_cmd = cmd + mod_dir_arg + mod_file_arg + reverse_arg

    branch = get_current_git_branch()

    print(f"{start_time_formatted}")
    print(f"Branch: {branch}")
    print(f"Action: {action}")
    print(f"Running: {' '.join(full_cmd)}")

    # TTSModManager can print an internal object-graph error ("order
    # expected X, not found in db <map[...]>") while still exiting 0 — an
    # asset silently failed to pack even though the process claims success.
    # Treat that pattern as a real failure so we never print "MOD BUILD
    # SUCCESS" over a build that's actually broken.
    result = subprocess.run(full_cmd, capture_output=True, text=True)
    combined_output = result.stdout + result.stderr
    build_failed = result.returncode != 0 or "not found in db" in combined_output

    if build_failed:
        print(result.stdout)
        print(result.stderr)
        raise subprocess.CalledProcessError(result.returncode, full_cmd)

    elapsed_time = time.time() - start_time
    print(f"Execution took {elapsed_time:.2f} seconds.")

    if action == "build":
        copy_preview_image(output_folder, branch)
        load_savegame_in_TTS()
        print_box("MOD BUILD SUCCESS")
    else:
        unescape_html_entities(moddir)
        print_box("DECOMPOSE SUCCESS")


def main():
    parser = argparse.ArgumentParser(
        description=f"VS Code build script for {GAME_NAME}"
    )
    parser.add_argument(
        "--action",
        required=True,
        choices=["build", "decompose"],
        help="Action to perform: build or decompose.",
    )
    parser.add_argument("--moddir", required=True, help="The mod directory.")
    args = parser.parse_args()

    run_build(args.moddir, args.action)


if __name__ == "__main__":
    main()
