"""Test main.py
"""

import os
import json
from unittest.mock import patch, Mock

from starlette.testclient import TestClient
from toolz.curried import pipe, curry
from fastapi import UploadFile
from click.testing import CliRunner
from boxsdk import JWTAuth

from main import app, get_auth, upload_to_box, get_config_filename


client = TestClient(app)  # pylint: disable=invalid-name


is_ = lambda x: (lambda y: x is y)  # pylint: disable=invalid-name
equals = lambda x: (lambda y: x == y)  # pylint: disable=invalid-name


@patch("main.JWTAuth")
def test_auth(jwtauth):
    """Thes the get_auth function
    """
    jwtauth.return_value = JWTAuth
    assert pipe(
        get_auth(
            dict(clientID="test", clientSecret="test"),
            dict(enterpriseID="test"),
            dict(publicKeyID="test", passphrase="test"),
        ),
        is_(JWTAuth),
    )


class MockStream(Mock):
    """Mock class for testing
    """

    @staticmethod
    def get_download_url():
        """Fake URL
        """
        return "https://test.com"

    id = 0

    def get_data(self):
        """Confirm the test data
        """
        return dict(file_id=self.id, download_link=self.get_download_url())


class MockFolder(Mock):
    """Mock class for testing
    """

    @staticmethod
    def create_subfolder(*_):
        """Fake folder
        """
        return MockFolder()

    @staticmethod
    def upload_stream(*_):
        """Fake stream
        """
        return MockStream()


class MockClient(Mock):
    """Mock class for testing
    """

    @staticmethod
    def folder(folder_id=None):
        """Fake folder
        """
        return MockFolder(name=folder_id)


@curry
def write_json(filename, data):
    """Write a JSON file. Used in the tests.
    """
    with open(filename, "w") as fstream:
        json.dump(data, fstream)
    return filename


def get_test_config():
    """Generate a fake config file
    """
    return pipe(
        dict(
            enterpriseID="test",
            boxAppSettings=dict(
                clientID="test",
                clientSecret="test",
                appAuth=dict(publicKeyID="test", passphrase="test"),
            ),
        ),
        write_json("test_config.json"),
    )


@patch("main.JWTAuth", autospec=True)
@patch("main.Client", new=MockClient)
@patch("main.get_config_filename", new=get_test_config)
def test_upload_to_box(*_):
    """Test the upload_to_box function
    """
    with CliRunner().isolated_filesystem():
        assert pipe(
            get_test_config(),
            upload_to_box(UploadFile("wow"), "test"),
            equals(MockStream().get_data()),
        )


@patch("main.JWTAuth", autospec=True)
@patch("main.Client", new=MockClient)
@patch("main.get_config_filename", new=get_test_config)
def test_upload_endpoint(*_):
    """Test the upload endpoint
    """
    with CliRunner().isolated_filesystem():
        assert pipe(
            "test.txt",
            write_json(data=dict(a=1)),
            lambda x: dict(fileb=open(x, "rb")),
            lambda x: client.post(f"/upload/", files=x),
            lambda x: x.json(),
            equals(MockStream().get_data()),
        )


def test_config_filename():
    """Test get_config_filename
    """
    assert pipe(
        get_config_filename(), os.path.basename, equals("1014649_e91k0tua_config.json")
    )
