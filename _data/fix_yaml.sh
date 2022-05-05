#!/bin/bash

# Update Yaml file to have the --- at the beginning
# Use with find and xargs
# $ find . -name '*.yml' -print | xargs ./fix_yaml.sh

for file in $@
do
    if [ "$(head -1 $file)" != '---' ]; then
        sed -i '1i ---' $file
    fi
done
