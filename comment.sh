#!/bin/bash

COMMENT="Testing commenting from Travis CI"

echo "$TRAVIS_PULL_REQUEST"
PULL_REQUEST_URL="https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}"
echo "$PULL_REQUEST_URL"
SIM_NAME=`curl -X GET "${PULL_REQUEST_URL}" | jq -r '.title' | sed -e 's/PFHub Upload: //'`
echo "$SIM_NAME"
META_YAML="${TRAVIS_BUILD_DIR}/_data/simulations/${SIM_NAME}/meta.yaml"
echo "$META_YAML"
TEMP=`cat ${META_YAML} | yq .metadata.author.github_id`
GITHUB_ID=`sed -e 's/\"//g' <<< ${TEMP}`
echo $GITHUB_ID
COMMENT="@${GITHUB_ID} testing comments..."
echo $COMMENT
if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$COMMENT\"}" "${PULL_REQUEST_URL}/comments";
fi
