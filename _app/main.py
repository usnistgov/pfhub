"""
Run this with

    $ uvicorn main:app --reload

Test the GET with

  $ url="https://drive.google.com/open?id=19oJVHZ6zaw47TN43E5qk-uGRsqrz0iE7"
  $ curl -L -o out.csv http://localhost:8000/get/?url=$url

  $ url="https://drive.google.com/open?id=1he7ilLH2VTD740OGPJXOq8CSn7utEDf_"
  $ curl -L -o out.png "http://localhost:8000/get/?url=$url"

"""

import re
from io import BytesIO
from fastapi import FastAPI
from pydantic import UrlStr
import requests
from toolz.curried import curry, get, compose
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import StreamingResponse


def sequence(*args):
    """Compose functions in order

    Args:
      args: the functions to compose

    Returns:
      composed functions

    >>> assert sequence(lambda x: x + 1, lambda x: x * 2)(3) == 8
    """
    return compose(*args[::-1])


app = FastAPI()  # pylint: disable=invalid-name


app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:4000", "https://pages.nist.gov"],
    allow_origin_regex=r"https://random-cat-.*\.surge\.sh",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


search = curry(re.search)  # pylint: disable=invalid-name


modify_google = sequence(  # pylint: disable=invalid-name
    search(r"[-\w]{25,}"),
    get(0),
    lambda x: str.format("https://drive.google.com/uc?export=download&id={0}", x),
)


@curry
def if_(if_func, func, arg):
    """Whether to apply a function or not
    """
    if if_func(arg):
        return func(arg)
    return arg


@app.get("/get/")
async def get_binary_file(url: UrlStr):
    """Base endpoint to get binary file
    """
    return sequence(
        if_(search(r"https://drive\.google\.com(.*)"), modify_google),
        requests.get,
        lambda x: (BytesIO(x.content), x.headers["content-type"]),
        lambda x: StreamingResponse(x[0], media_type=x[1]),
    )(url)


if __name__ == "__main__":
    # run with python main.py to debug
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
