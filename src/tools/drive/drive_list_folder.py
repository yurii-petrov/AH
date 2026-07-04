import sys
import warnings

warnings.filterwarnings("ignore")

from drive_upload import DRIVE_FOLDER_NAME, find_folder, get_service


def main():
    subfolder = sys.argv[1] if len(sys.argv) > 1 else None

    service = get_service()
    root_id = find_folder(service, DRIVE_FOLDER_NAME)

    folder_id = root_id
    if subfolder:
        for part in subfolder.split("/"):
            query = (
                f"name = '{part}' and mimeType = 'application/vnd.google-apps.folder' "
                f"and trashed = false and '{folder_id}' in parents"
            )
            results = service.files().list(q=query, spaces="drive", fields="files(id, name)").execute()
            files = results.get("files", [])
            if not files:
                print(f"Subfolder '{part}' not found under current folder.")
                return
            folder_id = files[0]["id"]

    query = f"'{folder_id}' in parents and trashed = false"
    results = service.files().list(
        q=query,
        spaces="drive",
        fields="files(id, name, mimeType, modifiedTime, size)",
        pageSize=1000,
    ).execute()
    files = results.get("files", [])

    print(f"{len(files)} item(s) in '{DRIVE_FOLDER_NAME}/{subfolder or ''}':")
    for f in files:
        kind = "DIR" if f["mimeType"] == "application/vnd.google-apps.folder" else "file"
        size = f.get("size", "-")
        print(f"  [{kind}] {f['name']}  id={f['id']}  size={size}  modified={f.get('modifiedTime')}")


if __name__ == "__main__":
    main()
