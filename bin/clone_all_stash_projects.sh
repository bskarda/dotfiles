#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo -n 'Password: '
read -r -s password
echo

PROJECTS=$(curl -L -k -s https://stash//rest/api/1.0/projects?limit=1000 | jq -r '.values | map (.key) | .[]')

for project in $PROJECTS; do
  mkdir -p "$project"
  pushd $project
  curl -k --user "$USER":"$password" https://stash/rest/api/1.0/projects/"$project"/repos?limit=2000 | jq --raw-output '.values | map(.links.clone | map(select(.name == "ssh")))[][] | .href ' | xargs -I {} git clone {}
  popd
done
