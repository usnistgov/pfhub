#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  STRING=`echo "${TRAVIS_PULL_REQUEST_BRANCH}" | cut -c1-9`
  if [ ${STRING} = "staticman" ]
  then
    PULL_REQUEST_URL="https://api.github.com/repos/${TRAVIS_PULL_REQUEST_SLUG}/issues/${TRAVIS_PULL_REQUEST}";
    SIM_NAME=`curl -X GET "${PULL_REQUEST_URL}" | jq -r '.title' | sed -e 's/PFHub Upload: //'`;
    META_YAML="${TRAVIS_BUILD_DIR}/_data/simulations/${SIM_NAME}/meta.yaml";
    TEMP=`cat ${META_YAML} | yq .metadata.author.github_id`;
    GITHUB_ID=`sed -e 's/\"//g' <<< ${TEMP}`;
    COMMENT="@${GITHUB_ID} testing comments...";
    curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$COMMENT\"}" "${PULL_REQUEST_URL}/comments";
  fi
fi
