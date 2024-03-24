# Automated Git Bisect GitHub Action

## Overview
This GitHub Action automates the `git bisect` process to help identify the commit that introduced a regression or bug in your project. By automating the bisect process, you can quickly pinpoint the exact commit causing the issue without manually checking each potential commit.

### Click on the Fork button at the top right of the GitHub repository page. This creates a personal copy of the repository where you can experiment with the actions.

## Test repository
- Test repository name: https://github.com/SweetRainGarden/SrgGitRecordsRepo
- [first bad commit in SrgGitRecordsRepo](https://github.com/SweetRainGarden/SrgGitRecordsRepo/commit/7abdb50f6b661a3e9039c3d4d315600da7b2729e), it should show up in the Action result summary.
- Result from an sample repo: https://github.com/SweetRainGarden/SrgGactionGittoolsRepo/actions/runs/8410715233

## Screenshots 
- ![image](https://github.com/SweetRainGarden/SrgGactionGittoolsRepo/assets/2296154/20f3002f-ed61-421e-963c-686767d8b8f0)
- ![image](https://github.com/SweetRainGarden/SrgGactionGittoolsRepo/assets/2296154/41c6847c-6437-4158-b5b1-8a9163e5b639)
- ![image](https://github.com/SweetRainGarden/SrgGactionGittoolsRepo/assets/2296154/073e06b0-f6fe-4af3-9a0c-541816758cb4)

## Features
- Automatically performs a binary search on your commit history to find the faulty commit.
- Configurable for different repositories, branches, and Java environments.
- Outputs the result directly in the GitHub Actions summary for easy access and review.

## Inputs

- `gh_token`: Optional. Your GitHub token for cloning and accessing the repository. If not provided, the default GitHub token is used. For public repository, the gh_token is not required.
- `org_repo`: Required. The organization and repository name (e.g., `org/repo`) where the bisect should be run.
- `init_branch_name`: Required. The branch name where the bisect process will start, defaulting to "develop".
- `good_commit`: Required. The commit hash that is known to be good.
- `bad_commit`: Optional. The commit hash suspected to be bad. If not provided, defaults to the latest commit of the `init_branch_name`.
- `check_commands`: Required. Commands to test each commit, separated by "&&".
- `java_version`: Optional. The Java version to use for the build, defaulting to '17'.

## How to Use

1. Navigate to the `Actions` tab in your GitHub repository.
2. Click on `New workflow` and find the `Automated Git Bisect` workflow, or select it if already present.
3. Click on `Run workflow`.
4. Fill in the required input parameters:
    - `org_repo`: "SweetRainGarden/SrgGitRecordsRepo"
    - `init_branch_name`: "develop"
    - `good_commit`: A known good commit hash.
    - `check_commands`: The commands to run for testing, like `./gradlew clean && ./gradlew test`.
    - Optionally, specify the `bad_commit` and `java_version` if needed.
5. Click on `Run workflow` to start the bisect process.

The action will then check out the specified branch, set up the required Java and Gradle environment, and start the `git bisect` process using the provided commands to determine the good and bad commits.

## Output
- The workflow will summarize the bisect results in the GitHub Actions summary, including:
  - The first bad commit ID.
  - A diff URL to view the changes in that commit.
  - The error log extracted from the bisect output.

## Contribution
Contributions to this GitHub Action are welcome. You can contribute by improving the scripts, adding features, or documenting use cases.

## License
This GitHub Action is released under the MIT License. See [LICENSE](LICENSE) for more details.
