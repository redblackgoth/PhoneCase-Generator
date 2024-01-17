#!/bin/sh
#
# copy to .git/hooks/pre-commit
#
# OpenSCAD doesn't preserve the order of JSON configs. It mangles the git history.
# Sort the config file alphabetically to keep the history consistent.

exec 1>&2

# sort attributes, strip Windows newlines
sorted=$(jq -S '.' phone_case.json  | tr -d '\r')
# readd to git
echo "$sorted" > phone_case.json