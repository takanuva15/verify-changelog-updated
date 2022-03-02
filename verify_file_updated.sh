#!/bin/bash

#function obtained from https://stackoverflow.com/a/2990533
echoerr() { printf "%s\n" "$*" >&2; }

#credit to https://stackoverflow.com/a/61922402 for providing a starting point for this script

# Fetch all changed files in this PR and verify the user-specified file is among the changes
pr_files_json=$(curl -s -u "$OWNER":"$GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$PR_API_URL/files")
pr_files=$(jq -r '.[] | .filename' <<<"$pr_files_json")

# shellcheck disable=SC2199
if [[ ! ${pr_files[@]} =~ ${FILENAME_TO_CHECK} ]]; then
  echoerr "Could not find '${FILENAME_TO_CHECK}' among the changed files in this PR! '${FILENAME_TO_CHECK}' must " \
    "be updated within the PR to pass this check."
  exit 1
fi

echo "Detected '${FILENAME_TO_CHECK}' among the changed files in this PR. Verification succeeded!"
