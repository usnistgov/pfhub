# PFHub App

Run with

    $ nix-shell --pure
    [nix-shell]$ uvicorn main:app --reload

Test with

    [nix-shell]$ py.test test.py

## Deploy to App Engine

    $ gcloud init
    $ gcloud app deploy

and

    $ glcoud app logs tail -s default

to observe the logs once deployed.
