#!/bin/sh
#
# Generate the version string from the commit date.
#

cd "`dirname \"$0\"`"


echo "{\"version\": \"`git log -1 --format=%cd --date=short | sed 's/-0/-/g' | tr - . `\"}" | tee ../version.json

