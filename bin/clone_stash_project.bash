#!/bin/bash

echo -n 'project: '
read -s project
echo

echo -n 'Password: '
read -s password
echo

curl -s  -k --user $USER:$password https:/stash/rest/api/1.0/projects/$project/repos?limit=2000 | jq --raw-output '.values | map(.links.clone | map(select(.name == "ssh")))[][] | .href ' | xargs -I {} git clone {}
