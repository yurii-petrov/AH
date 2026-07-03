import json
import os
import sys
import warnings

warnings.filterwarnings("ignore")

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

from asset_index_builder import ROOT_DIR, extract_google_id, print_box

# -------------------------
# UPLOAD ASSETS WITH A LOCAL FILE BUT NO DRIVE LINK YET, THEN RECORD THE
# RESULTING gUrl IN index.json.
#
# One-time setup (can't be automated — needs your own Google account):
#   1. console.cloud.google.com -> new project -> enable "Google Drive API".
#   2. Credentials -> Create Credentials -> OAuth client ID -> "Desktop app".
#      Download the JSON, save it as src/tools/credentials.json.
#   3. OAuth consent screen -> add yourself as a test user.
#   4. DRIVE_FOLDER_NAME below must already exist in your Drive, owned by
#      you (or shared with Editor access) — this script does not create the
#      root folder itself, only subfolders under it (mirroring assets/'s own
#      subfolder structure).
#
# First run opens a browser for you to sign in and grant access; after that
# it reuses src/tools/token.json (gitignored, do not commit either file).
# -------------------------

# drive.file (files created *by this app* only) can't see a folder that
# already existed before this script touched it — needed the full "drive"
# scope so find_folder() can locate a pre-existing shared folder by name.
SCOPES = ["https://www.googleapis.com/auth/drive"]
TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
CREDENTIALS_FILE = os.path.join(TOOLS_DIR, "credentials.json")
TOKEN_FILE = os.path.join(TOOLS_DIR, "token.json")
INDEX_FILE = os.path.join(TOOLS_DIR, "index.json")

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


def find_needing_upload(data):
    """Assets with a known local file that either have no Drive link yet
    ("new"), or do have one but the local file's content has changed since
    the last upload ("changed" — localHash, refreshed on every index scan,
    no longer matches uploadedHash, set only when this script last uploaded
    it)."""
    needing = []
    for rel_path, file_data in data.items():
        for asset in file_data.get("assets", []):
            local = asset.get("local")
            if not local:
                continue

            if not asset.get("gUrl"):
                needing.append((rel_path, asset["target"], local, "new"))
            elif asset.get("localHash") and asset.get("localHash") != asset.get("uploadedHash"):
                needing.append((rel_path, asset["target"], local, "changed"))

    return needing


def find_dead_drive_links(service, data, already_needing):
    """--verify only: hash-matching isn't enough if someone deletes the
    Drive file directly (from the Drive UI, outside this script) — the
    recorded gUrl/uploadedHash still looks "up to date" with nothing to
    contradict it, so the missing file goes unnoticed until something in
    TTS fails to load. Checks each *distinct* gUrl once (many assets can
    share one Drive file) via files.get, which is far cheaper than
    re-uploading everything to find out."""
    ids_seen = {}
    dead = []

    for rel_path, file_data in data.items():
        for asset in file_data.get("assets", []):
            local = asset.get("local")
            gurl = asset.get("gUrl")
            if not local or not gurl:
                continue
            if any(n[0] == rel_path and n[1] == asset["target"] for n in already_needing):
                continue

            file_id = extract_google_id(gurl)
            if not file_id:
                continue

            if file_id not in ids_seen:
                try:
                    service.files().get(fileId=file_id, fields="id", supportsAllDrives=True).execute()
                    ids_seen[file_id] = True
                except Exception:
                    ids_seen[file_id] = False

            if not ids_seen[file_id]:
                dead.append((rel_path, asset["target"], local, "dead-link"))

    return dead


def main():
    apply = "--apply" in sys.argv
    verify = "--verify" in sys.argv

    with open(INDEX_FILE, "r", encoding="utf-8") as f:
        index = json.load(f)
    data = index["data"]

    needing = find_needing_upload(data)

    service = None
    if verify:
        # Hash-matching alone can't catch a Drive file deleted directly from
        # the Drive UI (outside this script) — the recorded state still
        # looks "up to date" with nothing local to contradict it.
        service = get_service()
        dead = find_dead_drive_links(service, data, needing)
        if dead:
            print(f"{len(dead)} asset(s) point at a Drive file that no longer exists:")
            for rel_path, target, local, reason in dead:
                print(f"  [{reason}] {rel_path} {target}: {local}")
        needing = needing + dead

    if not needing:
        print_box("NO DRIVE UPLOADS NEEDED")
        return

    print(f"{len(needing)} asset(s) need a Drive upload:")
    for rel_path, target, local, reason in needing:
        print(f"  [{reason}] {rel_path} {target}: {local}")

    if not apply:
        print_box(f"DRY RUN — {len(needing)} PENDING (pass --apply to upload)")
        return

    if service is None:
        service = get_service()
    root_folder_id = find_folder(service, DRIVE_FOLDER_NAME)
    folder_cache = {(): root_folder_id}

    uploaded = {}  # local path -> gUrl, so the same file uploads once
    linked = 0
    old_ids_to_delete = set()  # every superseded Drive file id, across all replaced assets

    for rel_path, target, local, reason in needing:
        if local not in uploaded:
            abs_path = os.path.join(ROOT_DIR, *local.split("/"))
            if not os.path.isfile(abs_path):
                print(f"SKIP (file missing on disk): {abs_path}")
                continue

            # local looks like "assets/other_graphics/foo.png" — mirror
            # everything between the leading "assets" and the filename as
            # Drive subfolders, so the Drive tree matches the project's.
            local_parts = local.split("/")
            subfolder_parts = local_parts[1:-1]
            target_folder_id = resolve_drive_dir(service, root_folder_id, subfolder_parts, folder_cache)

            # Always create a fresh Drive file/id, even when replacing
            # existing content — TTS and Drive both cache aggressively by
            # URL, so reusing the old id risks stale art showing in-game.
            file_id = upload_file(service, target_folder_id, abs_path)
            gurl = f"https://drive.google.com/uc?export=download&id={file_id}"
            uploaded[local] = gurl
            print(f"Uploaded ({reason}): {local} -> {gurl}")

        gurl = uploaded.get(local)
        if not gurl:
            continue

        for asset in data[rel_path]["assets"]:
            if asset["target"] == target:
                # Every asset sharing this exact local file gets the *same*
                # new gUrl, not just the one whose own hash mismatch first
                # surfaced the change — otherwise other spots referencing
                # the identical file silently keep pointing at the
                # now-superseded Drive copy (see incident: a second
                # CustomUIAssets entry for the same local PNG kept its old
                # id because only one of the two entries had a hash to
                # compare against).
                old_gurl = asset.get("gUrl")
                if old_gurl and old_gurl != gurl:
                    old_id = extract_google_id(old_gurl)
                    if old_id:
                        old_ids_to_delete.add(old_id)

                # apply_asset_source.py --drive can only replace objects/
                # text it has an "old" candidate for — prevGUrl gives it the
                # superseded link so a same-source (drive -> drive) swap
                # isn't silently skipped (it otherwise only ever compares
                # against the *other* sources' current values).
                if old_gurl and old_gurl != gurl:
                    asset["prevGUrl"] = old_gurl
                asset["gUrl"] = gurl
                asset["uploadedHash"] = asset.get("localHash")
                linked += 1

        # Also catch sibling assets that reference the same local file but
        # weren't individually flagged by find_needing_upload (e.g. an old
        # asset whose own uploadedHash happened to already match — same
        # root cause as above, applied file-wide instead of per-target).
        for other_target_assets in data.values():
            for asset in other_target_assets.get("assets", []):
                if asset.get("local") == local and asset.get("gUrl") != gurl:
                    old_gurl = asset.get("gUrl")
                    if old_gurl:
                        old_id = extract_google_id(old_gurl)
                        if old_id:
                            old_ids_to_delete.add(old_id)
                        asset["prevGUrl"] = old_gurl
                    asset["gUrl"] = gurl
                    asset["uploadedHash"] = asset.get("localHash")
                    linked += 1

    deleted = 0
    for old_id in old_ids_to_delete:
        try:
            service.files().delete(fileId=old_id).execute()
            deleted += 1
        except Exception as e:
            print(f"Could not delete superseded Drive file {old_id}: {e}")

    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

    print_box(f"DRIVE UPLOAD SUCCESS ({len(uploaded)} UPLOADED, {linked} LINKED, {deleted} OLD DELETED)")


if __name__ == "__main__":
    main()
