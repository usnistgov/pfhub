#!/bin/bash

# This can't go directly in .travis.yml, see
# https://stackoverflow.com/questions/34687610/how-to-properly-use-curl-in-travis-ci-config-file-yaml

curl ${APP_URL}/comment/ -H "Content-Type: application/json" -X POST -d "$( envsubst < _app/payload.json )";
