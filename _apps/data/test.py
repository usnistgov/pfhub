"""Test main.py
"""

from starlette.testclient import TestClient
from toolz.curried import pipe
from main import app


client = TestClient(app)  # pylint: disable=invalid-name


def get(url):
    """Get the response given a file URL
    """
    return client.get(f"/get/?url={url}")


def test_csv():
    """Test the response with a CSV file
    """
    assert pipe(
        "https://drive.google.com/file/d/1F2Pzo2IYYPhPmU_mryjR6flz2vUDr5Zy/view?usp=sharing",
        get,
        lambda x: x.text.partition("\n")[0] == "Time,Total_Energy",
    )


def test_image():
    """Test the response with an image file
    """
    assert pipe(
        "https://drive.google.com/file/d/1b51dmOYwspNVMsaSoED2xUT3pfNq563B/view?usp=sharing",
        get,
        lambda x: x.headers["content-type"] == "image/png",
    )
