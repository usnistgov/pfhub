#!/bin/bash

# This can't go directly in .travis.yml, see
# https://stackoverflow.com/questions/34687610/how-to-properly-use-curl-in-travis-ci-config-file-yaml

HTTP_RESPONSE=$(curl ${APP_URL}/comment/ -H "Content-Type: application/json" -X POST -d "$( envsubst < _apps/data/payload.json )"  --silent --write-out "HTTPSTATUS:%{http_code}")
echo "HTTP_RESPONSE: ${HTTP_RESPONSE}"
