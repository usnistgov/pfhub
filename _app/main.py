"""Run this with

    $ uvicorn main:app --reload

Test the GET with

    $ url="https://drive.google.com/open?id=19oJVHZ6zaw47TN43E5qk-uGRsqrz0iE7"
    $ curl -L -o out.csv http://localhost:8000/get/?url=$url

    $ url="https://drive.google.com/open?id=1he7ilLH2VTD740OGPJXOq8CSn7utEDf_"
    $ curl -L -o out.png "http://localhost:8000/get/?url=$url"

Test comments with (remember to change allow_origins to ["*"] to test
on app engine from local machine)

    $ APP_URL="https://ace-thought-249120.appspot.com/comment/" # or http://localhost:8000/comment/
    $ curl ${APP_URL} -H "Content-Type: application/json" -X POST -d "$(cat <<EOF
    {
      "pr_number":"1089",
      "github_id":"wd15",
      "sim_name":"test",
      "benchmark_id": "3a",
      "is_staticman": true,
      "surge_domain": "https://random-cat-1089.surge.sh"
    }
EOF
)"

Setting env vars in YAML

  https://stackoverflow.com/questions/22669528/securely-storing-environment-variables-in-gae-with-app-yaml

Create 'env_variables.yaml' with

evn_variables:
  GITHUB_TOKEN: xxxxxx

"""

import re
from io import BytesIO
from fastapi import FastAPI
from pydantic import UrlStr
import requests
from toolz.curried import curry, get, compose
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import StreamingResponse
import json
import os
from pydantic import BaseModel, UrlStr


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
    # allow_origins=["http://127.0.0.1:4000", "https://pages.nist.gov"],
    allow_origins=["*"],
    # allow_origin_regex=r"https://random-cat-.*\.surge\.sh",
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


class Comment(BaseModel):
    pr_number: int
    github_id: str
    sim_name: str
    benchmark_id: str
    is_staticman: bool
    surge_domain: UrlStr


def comment_staticman(comment):
    return f"""
@{comment.github_id}, thanks for your PFHub upload!

You can view your upload display at

 - {comment.surge_domain}/simulations/display/?sim={comment.sim_name}

and

 - {comment.surge_domain}/simulations/{comment.benchmark_id}

Please check that the tests pass below and then review and confirm your approval to @wd15 by commenting in this pull request.

If you think there is a mistake in your upload data, then you can resubmit the upload [at this link]({comment.surge_domain}/simulations/upload_form/?sim={comment.sim_name}).
"""


def comment_general(comment):
    return f"""
The new [PFHub live website]({comment.surge_domain}) is ready for review.
"""

def make_comment(comment):


@app.post("/comment/")
async def comment_pr(comment: Comment):
    """Endpoint to post comment to GitHub PR
    """

    @curry
    def post(github_token, comment_string):
        return requests.post(
            f"https://api.github.com/repos/{comment.slug}/issues/{comment.pr_number}/comments",
            data=json.dumps({"body": comment_string}),
            headers={"Authorization": f"token {github_token}"},
        )

    return sequence(
        make_comment,
        post(os.environ.get("GITHUB_TOKEN")),
        lambda x: dict(status_code=x.status_code, json=x.json()),
    )(comment)


if __name__ == "__main__":
    # run with python main.py to debug
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
