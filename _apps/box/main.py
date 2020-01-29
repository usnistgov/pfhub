"""Run this with

    $ uvicorn main:app --reload

Test with

  curl -X "POST" -F "fileb=@./shell.nix" http://localhost:8000/upload/

or on the app with

  curl -X "POST" -F "fileb=@./shell.nix" https://pfhub-box.appspot.com/upload/

Todo:

 - set up test cases
 - test on heroku
"""


import os
import json
from uuid import uuid4
from toolz.curried import get, compose, get_in, juxt, identity
from starlette.middleware.cors import CORSMiddleware
from fastapi import FastAPI, File, UploadFile
from boxsdk import JWTAuth, Client
import uvicorn


def get_config_filename():
    """Get the full path to the local config file
    """
    return sequence(
        os.path.abspath,
        os.path.dirname,
        lambda x: os.path.join(x, "1014649_e91k0tua_config.json"),
    )(__file__)


def sequence(*args):
    """Compose functions in order

    Args:
      args: the functions to compose

    Returns:
      composed functions

    >>> assert sequence(lambda x: x + 1, lambda x: x * 2)(3) == 8
    """
    return compose(*args[::-1])


def get_auth(settings: dict, data: dict, app_auth: dict) -> JWTAuth:
    """Geneate the JWTAuth object

    Args:
      settings: the boxAppSettings key from config data
      data: all config data
      app_auth: the appAuth key from the settings config data

    Returns:
      a JWTAuth object

    """
    return JWTAuth(
        client_id=settings["clientID"],
        client_secret=settings["clientSecret"],
        enterprise_id=data["enterpriseID"],
        jwt_key_id=app_auth["publicKeyID"],
        rsa_private_key_file_sys_path="./cert.pem",
        rsa_private_key_passphrase=app_auth["passphrase"],
    )


def get_json(filename: str) -> str:
    """Read a JSON file

    Args:
      filename: the JSON filename

    Returns:
      the data as a dictionary

    """
    with open(filename) as file_stream:
        return json.load(file_stream)


def upload_to_box(upload_file: UploadFile, folder_name: str) -> dict:
    """Upload a file to box

    Args:
      upload_file: an UploadFile object
      folder_name: the folder to dump the file to

    Returns:
      function to upload the box file ID and the download URL

    """
    return sequence(
        get_json,
        juxt(get("boxAppSettings"), identity, get_in(["boxAppSettings", "appAuth"])),
        lambda x: get_auth(*x),
        Client,
        lambda x: x.folder(folder_id="0"),
        lambda x: x.create_subfolder(folder_name),
        lambda x: x.upload_stream(upload_file.file, upload_file.filename),
        lambda x: dict(file_id=x.id, download_link=x.get_download_url()),
    )


app = FastAPI()  # pylint: disable=invalid-name


app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://127.0.0.1:4000",
        "https://pages.nist.gov",
        "https//travis-ci.org",
    ],
    # allow_origins=["*"],
    allow_origin_regex=r"https://random-cat-.*\.surge\.sh",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/upload/")
async def upload(fileb: UploadFile = File(...)) -> dict:
    """End point to upload files to box
    """
    return upload_to_box(fileb, str(uuid4()))(get_config_filename())


if __name__ == "__main__":  # pragma: no cover
    uvicorn.run(app, host="0.0.0.0", port=8000)
