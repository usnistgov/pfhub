"""
Run this with

    $ uvicorn main:app --reload

Test the GET with

  $ url="https://drive.google.com/open?id=19oJVHZ6zaw47TN43E5qk-uGRsqrz0iE7"
  $ curl -L -o out.csv http://localhost:8000/get/?url=$url

  $ url="https://drive.google.com/open?id=1he7ilLH2VTD740OGPJXOq8CSn7utEDf_"
  $ curl -L -o out.png "http://localhost:8000/get/?url=$url"

Test comments

  $ curl -L -o out.csv "https://ace-thought-249120.appspot.com/comment?staticman=0&issue_number=1089"

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
    # allow_origins=["*"],
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


class Comment(BaseModel):
    pr_number: int
    github_id: str
    sim_name: str
    is_staticman: bool
    surge_domain: str
    benchmark_id: int

def comment_staticman(github_id, pfhub_link_sim, pfhub_link_comp, pfhub_link_edit):
    return f"""
@{github_id}, thanks for your PFHub upload! Your upload appears to have passed the tests.

You can view your upload display at

 - {link1}

and

 - {link2}

Please review and confirm your approval to @wd15 by commenting in this pull request.

If you think there is a mistake in your upload data, then you can resubmit the upload [at this link]({pfhub_link}).
    """

def comment_general(github_id, domain)




@app.post("/comment/")
async def github_comment(comment: Comment):
    """Endpoint to post comment to GitHub PR
    """
    github_token = os.environ.get('GITHUB_TOKEN')
    domain=f"https://random-cat-${comment.pr_number}.surge.sh"
    data = dict(
        pr_url=f"https://api.github.com/repos/usnistgov/pfhub/issues/{comment.pr_number}/comments",
        pfhub_link_sim=domain + "/simulations/display/?sim={comment.sim_name}"
        pfhub_link_comp=domain + "/simulations/{comment.benchmark_id}"
        pfhub_link_upload=domain + "/simulations/upload_form/?sim={comment.sim_name}"
        pfhub_link=domain
    )

    response = requests.post(
        url,
        data=json.dumps({'body': comment(data)}),
        headers={'Authorization': f'token {github_token}'}
    )
    return {'status_code': response.status_code, 'json': response.json()}



if __name__ == "__main__":
    # run with python main.py to debug
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
