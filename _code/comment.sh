#!/bin/bash

# Check to see if the branch being tested is "staticman_something".
# Comments are only posted for website uploads. Comments can't be
# posted when from a non usnistgov pull request as credentials can't
# be used on Travis CI in that case.
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


# Get the base path to the meta.yaml given the simulation name
function yaml_path {
    echo "_data/simulations/$1/meta.yaml"
}

# Get the total path on Travis to the meta_yaml given the simulation
# name
function meta_yaml {
    echo "${TRAVIS_BUILD_DIR}/$( yaml_path $1 )"
}

# Extract an item from the meta.yaml file given the simulation name
# and the item e.g. ".benchmark.version"
function get_from_meta {
    echo `sed -e 's/\"//g' <<< $( cat $( meta_yaml $1 ) | yq $2 )`
}

# Get the benchmark ID given the simulation name
function benchmark_id {
    echo "$( get_from_meta $1 .benchmark.id ).$( get_from_meta $1 .benchmark.version )"
}

# Get the GitHub ID given the simulation name
function github_id {
    echo "$( get_from_meta $1 .metadata.author.github_id )"
}

# Get the link to edit the meta.yaml on GitHub given the simulation
# name. This will fork the repository to the user's area.
function edit_link {
    echo "https://github.com/${TRAVIS_PULL_REQUEST_SLUG}/edit/${TRAVIS_PULL_REQUEST_BRANCH}/$( yaml_path $1 )?pr=%2Fusnistgov%2Fpfhub%2Fpull%2F${TRAVIS_PULL_REQUEST}"
}

# The link to the individual landing page given the simulation name
function link1 {
    echo "https://${DOMAIN}/simulations/display/?sim=$1"
}

# The link to the group landing page given the simulation name.
function link2 {
    echo "https://${DOMAIN}/simulations/$( benchmark_id $1 )"
}

# Get the comment to post given the simulation name
function comment {
    echo "@$( github_id $1 ), thanks for your PFHub upload! Your upload appears to have passed the tests.\n\nYou can view your upload display at\n\n - $( link1 $1 )\n\nand\n\n - $( link2 $1 )\n\nPlease review and confirm your approval to @wd15 by commenting in this pull request.\n\nYou can make further changes to this pull request by [editing the meta.yaml]($( edit_link $1 )) associated with this pull request.";
}

# Post the comment to GitHub given the simulation name
function post_comment {
    curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"$( comment $1 )\"}" "$( pull_request_url )/comments"
}

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
    if is_staticman_branch
    then
        HTTP_RESPONSE=$(curl -X GET "$( pull_request_url )" --silent --write-out "HTTPSTATUS:%{http_code}")
        HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
        HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
        if [ $HTTP_STATUS = "200" ]
        then
            SIM_NAME=`echo "${HTTP_BODY}" | jq -r '.title' | sed -e 's/PFHub Upload: //'`
            post_comment "$SIM_NAME"
        else
            echo "HTTP_RESPONSE: ${HTTP_RESPONSE}"
        fi
    fi
fi
