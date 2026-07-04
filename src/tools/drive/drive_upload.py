import json
import os
import sys
import warnings

warnings.filterwarnings("ignore")

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

from asset_index_builder import extract_google_id, print_box
from assets_manifest import diff as manifest_diff
from assets_manifest import drive_url, load_manifest, save_manifest, scan_assets, to_absolute_asset

# -------------------------
# UPLOAD ASSETS WITH A LOCAL FILE BUT NO DRIVE LINK YET, THEN RECORD THE
# RESULTING gUrl IN index.json.
#
# One-time setup (can't be automated — needs your own Google account):
#   1. console.cloud.google.com -> new project -> enable "Google Drive API".
#   2. Credentials -> Create Credentials -> OAuth client ID -> "Desktop app".
#      Download the JSON, save it as src/tools/drive/credentials.json.
#   3. OAuth consent screen -> add yourself as a test user.
#   4. DRIVE_FOLDER_NAME below must already exist in your Drive, owned by
#      you (or shared with Editor access) — this script does not create the
#      root folder itself, only subfolders under it (mirroring assets/'s own
#      subfolder structure).
#
# First run opens a browser for you to sign in and grant access; after that
# it reuses src/tools/drive/token.json (gitignored, do not commit either file).
# -------------------------

# drive.file (files created *by this app* only) can't see a folder that
# already existed before this script touched it — needed the full "drive"
# scope so find_folder() can locate a pre-existing shared folder by name.
SCOPES = ["https://www.googleapis.com/auth/drive"]
TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
CREDENTIALS_FILE = os.path.join(TOOLS_DIR, "credentials.json")
TOKEN_FILE = os.path.join(TOOLS_DIR, "token.json")
INDEX_FILE = os.path.join(os.path.dirname(TOOLS_DIR), "legacy", "index.json")

DRIVE_FOLDER_NAME = "assets"


def get_service():
    creds = None
    if os.path.exists(TOKEN_FILE):
        creds = Credentials.from_authorized_user_file(TOKEN_FILE, SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists(CREDENTIALS_FILE):
                print(f"Missing {CREDENTIALS_FILE} — see the setup steps at the top of this file.")
                sys.exit(1)
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_FILE, SCOPES)
            creds = flow.run_local_server(port=0)

        with open(TOKEN_FILE, "w", encoding="utf-8") as f:
            f.write(creds.to_json())

    return build("drive", "v3", credentials=creds)


def find_folder(service, name):
    query = f"name = '{name}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false"
    results = service.files().list(
        q=query,
        spaces="drive",
        fields="files(id, name, owners(emailAddress), capabilities(canAddChildren))",
    ).execute()
    files = results.get("files", [])

    if not files:
        print(f"Folder '{name}' not found in your Drive — create it or ask to be shared on it first.")
        sys.exit(1)

    def describe(f):
        owners = ", ".join(o.get("emailAddress", "?") for o in f.get("owners", []))
        can_add = f.get("capabilities", {}).get("canAddChildren")
        return f"id={f['id']} owner={owners} canAddChildren={can_add}"

    if len(files) > 1:
        print(f"Found {len(files)} folders named '{name}' — using the first writable one:")
        for f in files:
            print(f"  {describe(f)}")

    writable = [f for f in files if f.get("capabilities", {}).get("canAddChildren")]
    if not writable:
        print(f"None of the {len(files)} folder(s) named '{name}' are writable by this account:")
        for f in files:
            print(f"  {describe(f)}")
        print("Ask the folder owner for Editor access, or upload into a folder you own.")
        sys.exit(1)

    return writable[0]["id"]


def find_or_create_subfolder(service, parent_id, name):
    query = (
        f"name = '{name}' and mimeType = 'application/vnd.google-apps.folder' "
        f"and trashed = false and '{parent_id}' in parents"
    )
    results = service.files().list(q=query, spaces="drive", fields="files(id)").execute()
    files = results.get("files", [])
    if files:
        return files[0]["id"]

    metadata = {
        "name": name,
        "mimeType": "application/vnd.google-apps.folder",
        "parents": [parent_id],
    }
    created = service.files().create(body=metadata, fields="id").execute()
    return created["id"]


def resolve_drive_dir(service, root_folder_id, subfolder_parts, folder_cache):
    """Mirror the local assets/<subfolder_parts>/ path on Drive under the
    root folder, creating any missing subfolder along the way, and reusing
    already-created ones (folder_cache keyed by the path-so-far)."""
    path_key = ()
    folder_id = folder_cache[path_key]

    for part in subfolder_parts:
        path_key = path_key + (part,)
        if path_key not in folder_cache:
            folder_cache[path_key] = find_or_create_subfolder(service, folder_id, part)
        folder_id = folder_cache[path_key]

    return folder_id


def upload_file(service, folder_id, local_path):
    metadata = {"name": os.path.basename(local_path), "parents": [folder_id]}
    media = MediaFileUpload(local_path, resumable=True)
    uploaded = service.files().create(body=metadata, media_body=media, fields="id").execute()
    file_id = uploaded["id"]

    service.permissions().create(
        fileId=file_id,
        body={"type": "anyone", "role": "reader"},
    ).execute()

    return file_id


def seed_manifest_from_index(manifest, data):
    """The manifest starts out knowing nothing about Drive — backfill
    driveId/gUrl for any hash that index.json (built by asset_index_builder
    from the URLs actually embedded in objects/*.json) already recorded as
    uploaded. Matched by uploadedHash (the asset's actual content hash at
    upload time), not by path/local — a path match alone would wrongly
    carry the old gUrl forward onto an asset whose content has since changed
    (same path, new hash), silently masking a real edit as "nothing to do".
    Without this seeding at all, the first run after introducing the
    manifest would see every asset as "no driveId yet" and re-upload the
    entire library."""
    for file_data in data.values():
        for asset in file_data.get("assets", []):
            uploaded_hash = asset.get("uploadedHash")
            gurl = asset.get("gUrl")
            if not uploaded_hash or not gurl:
                continue

            entry = manifest.get(uploaded_hash)
            if not entry:
                continue

            if not entry.get("driveId"):
                entry["driveId"] = extract_google_id(gurl)


def sync_drive_metadata(service, file_id, new_path, root_folder_id, folder_cache):
    """A local rename/move doesn't need the file re-uploaded (the Drive id
    and gUrl stay valid either way), but leaves the Drive copy's own
    name/folder stale — this brings them back in line so browsing Drive
    directly still matches what's on disk, purely metadata, no re-upload."""
    subfolder_parts = new_path.split("/")[1:-1]
    new_name = new_path.split("/")[-1]
    target_folder_id = resolve_drive_dir(service, root_folder_id, subfolder_parts, folder_cache)

    current = service.files().get(fileId=file_id, fields="name, parents").execute()
    old_parents = current.get("parents", [])

    kwargs = {}
    if current.get("name") != new_name:
        kwargs["body"] = {"name": new_name}
    if target_folder_id not in old_parents:
        kwargs["addParents"] = target_folder_id
        if old_parents:
            kwargs["removeParents"] = ",".join(old_parents)

    if not kwargs:
        return False

    service.files().update(fileId=file_id, fields="id", **kwargs).execute()
    return True


def find_dead_manifest_links(service, manifest):
    """--verify only: hash-matching isn't enough if someone deletes the
    Drive file directly (from the Drive UI, outside this script) — the
    recorded gUrl still looks "up to date" with nothing to contradict it, so
    the missing file goes unnoticed until something in TTS fails to load."""
    dead = []
    for file_hash, entry in manifest.items():
        file_id = entry.get("driveId")
        if not file_id:
            continue

        try:
            service.files().get(fileId=file_id, fields="id", supportsAllDrives=True).execute()
        except Exception:
            dead.append(file_hash)

    return dead


def main():
    apply = "--apply" in sys.argv
    verify = "--verify" in sys.argv

    with open(INDEX_FILE, "r", encoding="utf-8") as f:
        index = json.load(f)
    data = index["data"]

    old_manifest = load_manifest()
    manifest = scan_assets(old_manifest)
    seed_manifest_from_index(manifest, data)

    needing = [h for h, entry in manifest.items() if not entry.get("driveId")]

    _, _, renamed = manifest_diff(old_manifest, manifest)
    to_reconcile = [
        (file_hash, sorted(new_paths)[0])
        for file_hash, old_paths, new_paths in renamed
        if manifest[file_hash].get("driveId")
    ]

    service = None
    if verify:
        # Hash-matching alone can't catch a Drive file deleted directly from
        # the Drive UI (outside this script) — the recorded state still
        # looks "up to date" with nothing local to contradict it.
        service = get_service()
        dead = find_dead_manifest_links(service, manifest)
        if dead:
            print(f"{len(dead)} asset(s) point at a Drive file that no longer exists:")
            for file_hash in dead:
                for path in manifest[file_hash]["paths"]:
                    print(f"  [dead-link] {path}")
        needing = list(set(needing) | set(dead))

    if not needing and not to_reconcile:
        save_manifest(manifest)
        print_box("NO DRIVE CHANGES NEEDED")
        return

    if needing:
        print(f"{len(needing)} asset(s) need a Drive upload:")
        for file_hash in needing:
            for path in manifest[file_hash]["paths"]:
                print(f"  {path}")

    if to_reconcile:
        print(f"{len(to_reconcile)} asset(s) renamed/moved locally — Drive file will be renamed to match:")
        for file_hash, new_path in to_reconcile:
            print(f"  -> {new_path}")

    if not apply:
        save_manifest(manifest)
        print_box(f"DRY RUN — {len(needing)} UPLOAD(S), {len(to_reconcile)} RENAME(S) PENDING (pass --apply)")
        return

    if service is None:
        service = get_service()
    root_folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    folder_cache = {(): root_folder_id}

    uploaded = 0
    linked = 0
    unwired = []  # uploaded but not referenced by anything in objects/*.json yet
    old_ids_to_delete = set()  # every superseded Drive file id, across all replaced assets

    for file_hash in needing:
        entry = manifest[file_hash]
        paths = list(entry["paths"])
        paths_lower = {p.lower() for p in paths}
        primary_path = paths[0]
        abs_path = to_absolute_asset(primary_path)
        if not os.path.isfile(abs_path):
            print(f"SKIP (file missing on disk): {abs_path}")
            continue

        # local looks like "assets/other_graphics/foo.png" — mirror
        # everything between the leading "assets" and the filename as
        # Drive subfolders, so the Drive tree matches the project's.
        subfolder_parts = primary_path.split("/")[1:-1]
        target_folder_id = resolve_drive_dir(service, root_folder_id, subfolder_parts, folder_cache)

        # Always create a fresh Drive file/id, even when replacing existing
        # content — TTS and Drive both cache aggressively by URL, so reusing
        # the old id risks stale art showing in-game.
        file_id = upload_file(service, target_folder_id, abs_path)
        gurl = drive_url(file_id)
        entry["driveId"] = file_id
        uploaded += 1
        print(f"Uploaded: {primary_path} -> {gurl}")

        matched = False
        for file_data in data.values():
            for asset in file_data.get("assets", []):
                local = asset.get("local")
                if not local or local.lower() not in paths_lower:
                    continue
                matched = True

                # apply_asset_source.py --drive can only replace objects/
                # text it has an "old" candidate for — prevGUrl gives it the
                # superseded link so a same-source (drive -> drive) swap
                # isn't silently skipped.
                old_gurl = asset.get("gUrl")
                if old_gurl and old_gurl != gurl:
                    old_id = extract_google_id(old_gurl)
                    if old_id:
                        old_ids_to_delete.add(old_id)
                    asset["prevGUrl"] = old_gurl

                asset["gUrl"] = gurl
                asset["uploadedHash"] = file_hash
                linked += 1

        if not matched:
            unwired.append((primary_path, file_id, gurl))

    deleted = 0
    for old_id in old_ids_to_delete:
        try:
            service.files().delete(fileId=old_id).execute()
            deleted += 1
        except Exception as e:
            print(f"Could not delete superseded Drive file {old_id}: {e}")

    reconciled = 0
    for file_hash, new_path in to_reconcile:
        entry = manifest[file_hash]
        try:
            if sync_drive_metadata(service, entry["driveId"], new_path, root_folder_id, folder_cache):
                reconciled += 1
                print(f"Renamed on Drive: -> {new_path}")
        except Exception as e:
            print(f"Could not rename Drive file {entry['driveId']} to match {new_path}: {e}")

    save_manifest(manifest)
    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

    if unwired:
        print(f"\n{len(unwired)} file(s) uploaded but not referenced anywhere in objects/*.json yet:")
        for path, file_id, gurl in unwired:
            print(f"  {path}  id={file_id}  {gurl}")

    print_box(f"DRIVE UPLOAD SUCCESS ({uploaded} UPLOADED, {linked} LINKED, {deleted} OLD DELETED, {reconciled} RENAMED)")


if __name__ == "__main__":
    main()
