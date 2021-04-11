# verify-changelog-updated GitHub Action
A simple GitHub Action that runs a sanity check on your PRs to verify that the changelog file has been updated. (If you're anything like me, you may have merged a PR or two while completely forgetting to update the changelog)

## Getting Started
Assuming you have a file named `CHANGELOG.md` within the root of your repository, add the following to a new file `.github\workflows\verify_pr.yml`:

```yaml
name: Run PR Checks
on:
  pull_request:
    branches:
    - main

jobs:
  check_changelog:
    runs-on: ubuntu-latest
    name: Verify Changelog Updated
    steps:
    - name: Verify Changelog Updated
      uses: takanuva15/verify-changelog-updated@v1
```
Commit the file and create a PR to `main` - you should see the action run.

## Additional Usage Parameters
There are two additional parameters you can specify for the GitHub action:
- `excused_label`: A label that, when added to the PR, will exempt the PR from needing to satisfy the changelog check.
  - Default is `changelog update optional`
- `changelog_filename`: The name of the changelog file. The GitHub Action will verify whether this file has been updated within the PR.
  - Default is `CHANGELOG.md`
- `token`: The authentication token to use for accessing the PR's information. A token is required in order to view the files changed in a PR.
  - Default is `"${{ github.token }}"`

(Both parameters are case-sensitive)

Sample usage:
```yaml
steps:
  - name: Verify Changelog Updated
    uses: takanuva15/verify-changelog-updated@v1
    with:
      excused_label: my_custom_label
      changelog_filename: changelog.txt
      token: ${{ secrets.MY_TOKEN }}
```

## Notes
If you add a label after a PR has already been created, you will need to trigger a fresh build by pushing (or force-pushing) a commit. (This is due to GitHub caching the PR data when the PR is created, so a commit is required in order to refresh the cache)

## Contributing
We are happy to take contributions. If you experience an issue or see something that can be improved, feel free to raise an issue. Assuming that there is agreement on the issue, fork the repo and raise a PR to make your change.

If you like this action, feel free to star/watch the repo to show your support!

## Credits
- Credit to [Zomzog/changelog-checker](https://github.com/Zomzog/changelog-checker) as the inspiration for this GitHub action.
- Credit to various stackoverflow questions for answering my queries regarding bash & jq. (Links are provided in the bash script's comments)

