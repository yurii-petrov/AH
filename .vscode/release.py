#!/usr/bin/env python3
"""Cut a release: tags the current main commit on GitHub and creates a
release for it via the GitHub CLI. Publishing the release triggers
.github/workflows/build-mod.yml (on: release: types: [created]), which
builds the mod with TTSModManager and attaches it to the release.

Usage:
    python3 release.py <version>   # e.g. "3.2" or "v3.2"

Installs the GitHub CLI (`gh`) automatically if missing (via Homebrew on
macOS, winget on Windows), then prompts an interactive `gh auth login` if
not yet authenticated.
"""
import shutil
import subprocess
import sys


def run(cmd, **kwargs):
    print("+ " + " ".join(cmd))
    return subprocess.run(cmd, check=True, **kwargs)


def capture(cmd):
    return subprocess.run(cmd, check=True, capture_output=True, text=True).stdout.strip()


def has_gh():
    return shutil.which("gh") is not None


def install_gh():
    print("GitHub CLI ('gh') not found, attempting to install it...")
    if sys.platform == "darwin":
        if not shutil.which("brew"):
            print("Homebrew not found. Install gh manually: https://cli.github.com", file=sys.stderr)
            return False
        installer = ["brew", "install", "gh"]
    elif sys.platform == "win32":
        if not shutil.which("winget"):
            print("winget not found. Install gh manually: https://cli.github.com", file=sys.stderr)
            return False
        installer = ["winget", "install", "--id", "GitHub.cli", "-e", "--source", "winget"]
    else:
        print("Unsupported platform for auto-install. Install gh manually: https://cli.github.com", file=sys.stderr)
        return False

    try:
        run(installer)
    except subprocess.CalledProcessError:
        print("Failed to install gh automatically. Install it manually: https://cli.github.com", file=sys.stderr)
        return False

    return has_gh()


def ensure_gh_ready():
    if not has_gh() and not install_gh():
        return False

    if subprocess.run(["gh", "auth", "status"], capture_output=True).returncode != 0:
        print("gh is not authenticated yet — opening `gh auth login`...")
        try:
            run(["gh", "auth", "login"])
        except subprocess.CalledProcessError:
            print("gh auth login failed or was cancelled.", file=sys.stderr)
            return False

    return True


def main():
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        print("Usage: release.py <version>  (e.g. 3.2 or v3.2)", file=sys.stderr)
        return 2

    version = sys.argv[1].strip()
    tag = version if version.lower().startswith("v") else f"v{version}"

    if not ensure_gh_ready():
        return 1

    if capture(["git", "status", "--porcelain"]):
        print("Working tree is not clean — commit or stash changes before releasing.", file=sys.stderr)
        return 1

    branch = capture(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    if branch != "main":
        print(f"You are on '{branch}', not 'main'. Release tags should be cut from main.", file=sys.stderr)
        return 1

    run(["git", "fetch", "origin", "main", "--tags"])

    local_head = capture(["git", "rev-parse", "HEAD"])
    remote_head = capture(["git", "rev-parse", "origin/main"])
    if local_head != remote_head:
        print("Local main is not in sync with origin/main. Pull/push first, then re-run.", file=sys.stderr)
        return 1

    if capture(["git", "tag", "--list", tag]):
        print(f"Tag {tag} already exists.", file=sys.stderr)
        return 1

    run(["gh", "release", "create", tag, "--target", "main", "--title", tag, "--generate-notes"])

    print(f"\nRelease {tag} created — build-mod workflow will attach the built mod shortly.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
