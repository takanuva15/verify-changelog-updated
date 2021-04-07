#!/bin/bash

#function obtained from https://stackoverflow.com/a/2990533
echoerr() { printf "%s\n" "$*" >&2; }

#credit to https://stackoverflow.com/a/61922402 for providing a starting point for this script
github_context_info_json=$(cat "$GITHUB_EVENT_PATH")

# Step 1: Check that the execution context is a PR
if ! jq --exit-status 'has("pull_request")' <<<"$github_context_info_json" >/dev/null; then
  echoerr "PR info could not be found! This action should only be run in the context of a PR. Please verify this " \
    "action is only being triggered on 'pull_request'. (See this action\"s README for more info)"
  exit 1
fi

# Step 2: Check that the PR doesn't have an excused label to ignore the changelog check
pr_info_json=$(jq --raw-output '.pull_request' <<<"$github_context_info_json")
pr_labels=$(jq -r '.labels[] | .name' <<<"$pr_info_json")

#function obtained from https://stackoverflow.com/a/15394738
# shellcheck disable=SC2199
if [[ ${pr_labels[@]} =~ ${EXCUSED_LABEL} ]]; then
  echo "PR has label '$EXCUSED_LABEL', so no changelog update is required."
  exit 0
fi

# Step 3: Fetch all changed files in this PR and verify the changelog file is among the changes
owner=$(jq -r '.base.repo.owner.login' <<<"$pr_info_json")
pr_api_url=$(jq -r '._links.self.href' <<<"$pr_info_json")
if ! curl --silent --fail --user "$owner":"$GITHUB_TOKEN" "$pr_api_url" >/dev/null; then
  echoerr "Could not fetch info about the current PR. Was the GitHub token set in the workflow file?"
  exit 1
fi

pr_files_json=$(curl -s -u "$owner":"$GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$pr_api_url/files")
pr_files=$(jq -r '.[] | .filename' <<<"$pr_files_json")

# shellcheck disable=SC2199
if [[ ! ${pr_files[@]} =~ ${CHANGELOG_FILENAME} ]]; then
  echoerr "Could not find '${CHANGELOG_FILENAME}' among the changed files in this PR! '${CHANGELOG_FILENAME}' must " \
    "be updated within the PR to pass this check."
  exit 1
fi

echo "Detected '${CHANGELOG_FILENAME}' among the changed files in this PR. Verification succeeded!"
