# Play with FastAPI

Run this with

    $ nix-shell --pure
    [nix-shell]$ uvicorn main:app --reload

Test with

    $ url="https://drive.google.com/open?id=19oJVHZ6zaw47TN43E5qk-uGRsqrz0iE7"
    $ curl -L -o out.csv http://localhost:8000/get/?url=$url

and

    $ url="https://drive.google.com/open?id=1he7ilLH2VTD740OGPJXOq8CSn7utEDf_"
    $ curl -L -o out.png "http://localhost:8000/get/?url=$url"

## Deploy to App Engine

    $ gcloud init
    $ gcloud deploy app

and

    $ glcoud app logs tail -s default

to observe the logs once deployed.
