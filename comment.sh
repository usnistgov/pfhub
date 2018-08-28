#!/bin/bash

COMMENT="Testing commenting from Travis CI"

echo ""
echo "check stuff"

ls $TRAVIS_BUILD_DIR/_data/simulations

echo "uncheck stuff"
echo ""

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$COMMENT\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments";
fi
