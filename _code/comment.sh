#!/bin/bash

TRAVIS_PULL_REQUEST="837"
TRAVIS_PULL_REQUEST_BRANCH="staticman_test"
TRAVIS_BUILD_DIR="/home/wd15/git/pfhub"
TRAVIS_PULL_REQUEST_SLUG="usnistgov/pfhub"
DOMAIN="random-cat-${TRAVIS_PULL_REQUEST}.surge.sh"

function is_staticman_branch {
    if [ `echo "${TRAVIS_PULL_REQUEST_BRANCH}" | cut -c1-9` = "staticman" ]
    then
        true
    else
        false
    fi
}

function pull_request_url {
    echo "https://api.github.com/repos/${TRAVIS_PULL_REQUEST_SLUG}/issues/${TRAVIS_PULL_REQUEST}";
}

function sim_name {
    echo `curl -X GET "$( pull_request_url )" | jq -r '.title' | sed -e 's/PFHub Upload: //'`
}

function yaml_path {
    echo "_data/simulations/$1/meta.yaml"
}

function meta_yaml {
    echo "${TRAVIS_BUILD_DIR}/$( yaml_path $1 )"
}

function get_from_meta {
    echo `sed -e 's/\"//g' <<< $( cat $( meta_yaml $1 ) | yq $2 )`
}

function benchmark_id {
    echo "$( get_from_meta $1 .benchmark.id ).$( get_from_meta $1 .benchmark.version )"
}

function github_id {
    echo "$( get_from_meta $1 .metadata.author.github_id )"
}

function edit_link {
    echo "https://github.com/${TRAVIS_PULL_REQUEST_SLUG}/edit/${TRAVIS_PULL_REQUEST_BRANCH}/$( yaml_path $1 )?pr=%2Fusnistgov%2Fpfhub%2Fpull%2F${TRAVIS_PULL_REQUEST}"
}

function link1 {
    echo "https://${DOMAIN}/simulations/display/?sim=$1"
}

function link2 {
    echo "https://${DOMAIN}/simulations/$( benchmark_id $1 )"
}

function comment {
    echo "@$( github_id $1 ), thanks for your PFHub upload! Your upload appears to have passed the tests.\n\nYou can view your upload display at\n\n - $( link1 $1 )\n\nand\n\n - $( link2 $1 )\n\nPlease review and confirm your approval to @wd15 by commenting in this pull request.\n\nYou can make further changes to this pull request by [editing the meta.yaml]($( edit_link $1 )) associated with this pull request.";
}

function post_comment {
    curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$( comment $( sim_name ) )\"}" "$( pull_request_url )/comments"
}

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
    if is_staticman_branch
    then
        post_comment
    fi
fi
