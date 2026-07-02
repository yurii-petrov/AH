import sys

from asset_index_builder import DRIVE_ROOT, scan

CLOUDSTORAGE_ROOT = (
    "/Users/yurii/Library/CloudStorage/GoogleDrive-pe.ur.ur@gmail.com"
    "/.shortcut-targets-by-id/1k8CucmQX-VhCXDhhNpSZieU02tm_jSRF"
    "/Arkham Horror (TTS)"
)


# -------------------------
# BUILD file:// URI FROM A DRIVE_ROOT-BASED LOCAL PATH
# -------------------------
def build_file_uri(local_path: str) -> str:
    cloud_path = local_path.replace(DRIVE_ROOT, CLOUDSTORAGE_ROOT, 1)
    return "file:////" + cloud_path.lstrip("/")


# -------------------------
# COLLECT PLANNED REPLACEMENTS
# -------------------------
def collect_replacements(index):
    replacements_by_file = {}
    missing = []

    for file_name, file_data in index.items():
        file_path = file_data["path"]

        for asset in file_data.get("assets", []):
            google = asset.get("google", {})
            link = google.get("link")
            local = google.get("local")

            if not link:
                continue

            if not local:
                missing.append((file_name, asset.get("target"), link))
                continue

            new_url = build_file_uri(local)
            replacements_by_file.setdefault(file_path, []).append((link, new_url))

    return replacements_by_file, missing


# -------------------------
# APPLY REPLACEMENTS
# -------------------------
def apply_replacements(replacements_by_file, apply):
    files_touched = 0
    urls_replaced = 0

    for file_path, replacements in replacements_by_file.items():
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        original = content
        for old_url, new_url in replacements:
            if old_url in content:
                content = content.replace(old_url, new_url)
                urls_replaced += 1

        if content != original:
            files_touched += 1
            print(f"{'WRITE' if apply else 'PLAN'}: {file_path} ({len(replacements)} url(s))")

            if apply:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content)

    return files_touched, urls_replaced


# -------------------------
# MAIN
# -------------------------
def main():
    apply = "--apply" in sys.argv

    index = scan()
    replacements_by_file, missing = collect_replacements(index)
    files_touched, urls_replaced = apply_replacements(replacements_by_file, apply)

    print()
    print("DONE" if apply else "DRY RUN (pass --apply to write changes)")
    print("Files touched:", files_touched)
    print("URLs replaced:", urls_replaced)

    if missing:
        print()
        print("Missing local files (skipped):", len(missing))
        for file_name, target, link in missing:
            print(f"  {file_name} {target}: {link}")


if __name__ == "__main__":
    main()
