#!/bin/bash

set -xeuo pipefail
IFS=$'\n\t'

if [[ "$STASH_USER" == "" || "$STASH_PASS" == "" ]]; then
  echo "FATAL: You need to set STASH_USER and/or STASH_PASS"
  exit 1
fi

STASH_HOST=https://stash/projects/ANL
STASH_URL=https://${STASH_USER}:${STASH_PASS}@${STASH_HOST}

while read projectPath; do
  projectName=$(echo $projectPath | sed -e 's/^\/projects\///')

  while read cloneUrl; do
    repoName=$(basename $cloneUrl | sed -e 's/\.git$//')

    projectJson=$(curl -k -s ${STASH_URL}/rest/api/1.0${projectPath}/repos/${ressoName})

    # ignore forks
    if echo $projectJson | jq -e 'has("origin")' &>/dev/null; then
      continue;
    fi

    defaultBranch=$(curl -k -s ${STASH_URL}/rest/api/1.0${projectPath}/repos/${repoName}/branches/default | jq '.displayId')

    echo "Fetching $projectName/$repoName ($defaultBranch)..."

    mkdir -p $projectName

    pushd $projectName &>/dev/null
    if [[ -d $repoName/.git ]]; then
      pushd $repoName &>/dev/null
      sem --jobs 20 --id $projectName "git fetch; git checkout $defaultBranch; git pull --rebase"
      popd &>/dev/null
    else
      sem --jobs 20 --id $projectName "git clone $cloneUrl"
    fi
    popd &>/dev/null

  done < <(curl -k -s ${STASH_URL}/rest/api/1.0${projectPath}/repos?limit=500 | jq -r '.values[].links.clone[] | select(.name=="ssh") | .href')

  sem --wait --id $projectName

done < <(curl -k -s ${STASH_URL}/rest/api/1.0/projects?limit=500 | jq -r '.values[].link.url')
