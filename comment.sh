#!/bin/bash

COMMENT="Testing commenting from Travis CI"

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$COMMENT\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments";
fi
