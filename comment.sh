#!/bin/bash

COMMENT="Testing commenting from Travis CI"

echo "got here 0"
echo "$TRAVIS_PULL_REQUEST"
if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  echo "git here 1"
  echo "${TRAVIS_REPO_SLUG}"
  echo "${GITHUB_TOKEN_1}"
  curl -H "Authorization: token ${GITHUB_TOKEN_1}" -X POST -d "{\"body\": \"$COMMENT\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments";
fi
