#!/bin/bash

COMMENT="Testing commenting from Travis CI"

echo "got here 0"
echo "$TRAVIS_PULL_REQUEST"
if [ "$TRAVIS_PULL_REQUEST" = "true" ]
then
  echo "git here 1"
  echo "${TRAVIS_REPO_SLUG}"
  curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$COMMENT\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments";
fi
