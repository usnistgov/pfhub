"""Generate a shared Box folder to store data in an admins' account

"""

from toolz.curried import juxt, get, get_in, identity
from boxsdk.object.collaboration import CollaborationRole

from main import get_config_filename, get_json, get_auth, Client


def shared_folder():
    """Generate a shared Box folder
    """
    fname = get_config_filename()
    json = get_json(fname)
    data = juxt(get("boxAppSettings"), identity, get_in(["boxAppSettings", "appAuth"]))(
        json
    )
    auth = get_auth(*data)
    client = Client(auth)

    root_folder = client.folder(folder_id="0")
    pfhub_uploads = root_folder.create_subfolder("pfhub_uploads")
    pfhub_uploads.add_collaborator("daniel.wheeler@nist.gov", CollaborationRole.EDITOR)
    print("pfhub shared folder id:", pfhub_uploads.id)


if __name__ == "__main__":
    shared_folder()
