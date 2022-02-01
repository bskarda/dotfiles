#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo -n 'project: '
read -r project
echo

echo -n 'Password: '
read -r -s password
echo

curl -k --user "$USER":"$password" https://stash.cvent.net/rest/api/1.0/projects/"$project"/repos?limit=2000 | jq --raw-output '.values | map(.links.clone | map(select(.name == "ssh")))[][] | .href ' | xargs -I {} git clone {}
