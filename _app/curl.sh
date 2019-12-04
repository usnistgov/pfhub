#!/bin/bash

# This can't go directly in .travis.yml, see
# https://stackoverflow.com/questions/34687610/how-to-properly-use-curl-in-travis-ci-config-file-yaml

echo $TRAVIS_PULL_REQUEST
echo $DATA
HTTP_RESPONSE=$(curl ${APP_URL}/comment/ -H "Content-Type: application/json" -X POST -d "${DATA}"  --silent --write-out "HTTPSTATUS:%{http_code}")
echo "HTTP_RESPONSE: ${HTTP_RESPONSE}"
