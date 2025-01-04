# Action Tagger

[![build](https://github.com/StevenJDH/action-tagger/actions/workflows/bash-action-workflow.yml/badge.svg?branch=main)](https://github.com/StevenJDH/action-tagger/actions/workflows/bash-action-workflow.yml)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/StevenJDH/action-tagger?include_prereleases)
[![Public workflows that use this action.](https://img.shields.io/endpoint?style=flat&url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3DStevenJDH%2Faction-tagger%26badge%3Dtrue)](https://github.com/search?o=desc&q=StevenJDH+action-tagger+language%3AYAML&s=&type=Code)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a8ae369daa344226b27d34db9c1ae9ef)](https://app.codacy.com/gh/StevenJDH/action-tagger/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
![Maintenance](https://img.shields.io/badge/yes-4FCA21?label=maintained&style=flat)
![GitHub](https://img.shields.io/github/license/StevenJDH/action-tagger)

Action Tagger automatically sets semantic tags when releasing a new version of a GitHub action. This action adheres to GitHub's [action versioning guide](https://github.com/actions/toolkit/blob/master/docs/action-versioning.md#versioning), and removes the tedious task of having to manually set and shift tags like `v1` and `v1.2` to ensure they always point to a newer release. Tags produced and managed by this action will continue to work alongside other methods for referencing a release such as pointing to a branch, SHA, or other tags to meet different needs. In fact, Action Tagger currently manages its own release tags in a very similar way as described further down.

[![Buy me a coffee](https://img.shields.io/static/v1?label=Buy%20me%20a&message=coffee&color=important&style=flat&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/stevenjdh)

## Features

* Automate the setting and shifting of first and second level semantic tags.
* Optionally set a `latest` tag to use as an alternative to pointing to `main`.
* Support for working in conjunction with other automated workflows like release generators.
* Tag format is validated during a run to ensure correct conformity.
* Support for running the action in a dry run mode without making actual changes.
* Summary reports are generated after each run.
* Reference outputs of managed tags for additional possibilities.

## Compatibility
Below is a list of GitHub-hosted runners that support jobs using this action.

| Runner     | Supported? | 
|------------|:----------:|
| [![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat&logo=ubuntu&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on) | :white_check_mark: |
| [![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat\&logo=windows\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on) | :white_check_mark: |
| [![macOS](https://img.shields.io/badge/macOS-000000?style=flat\&logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on) | :white_check_mark: |

## Inputs
The following inputs are available:

| Name                                                                         | Type     | Required | Default                         |  Description                                                        |
|------------------------------------------------------------------------------|----------|:--------:|:-------------------------------:|---------------------------------------------------------------------|
| <a name="enable-dry-run"></a>[enable&#x2011;dry&#x2011;run](#enable-dry-run) | `string` | `false`  | `false`                         | Indicates whether or not to perform a dry run without pushing tags. |
| <a name="set-latest-tag"></a>[set&#x2011;latest&#x2011;tag](#set-latest-tag) | `string` | `false`  | `false`                         | Indicates whether or not to also set the latest tag.                |
| <a name="release-version"></a>[release&#x2011;version](#release-version)     | `string` | `false`  | <code>&#xFEFF;$&#xFEFF;{{&#xa0;github.ref&#xa0;}}</code> | Overrides the release version used for processing (e.g., `v1.0.0` or `refs/tags/v1.0.0`). |
| <a name="github-token"></a>[github&#x2011;token](#github-token)              | `string` | `false`  | <code>&#xFEFF;$&#xFEFF;{{&#xa0;github.token&#xa0;}}</code> | Overrides the default GitHub token used to authenticate against a repository for Git context. |

> [!NOTE]  
> Enabling dry run will use a dummy version of v1.0.0 regardless of what version tags are available, or what override value is provided.

## Outputs
The following outputs are available:

| Name                                                        | Type     | Example | Description                                      |
|-------------------------------------------------------------|----------|---------|--------------------------------------------------|
| <a name="major_release"></a>[major_release](#major_release) | `string` | v1      | The latest major release version.                |
| <a name="minor_release"></a>[minor_release](#minor_release) | `string` | v1.2    | The latest major and feature release version.    |
| <a name="full_release"></a>[full_release](#full_release)    | `string` | v1.2.3  | The full release version.                        |
| <a name="latest_tag"></a>[latest_tag](#latest_tag)          | `string` | false   | Indicates whether of not the latest tag was set. |

## Usage
Implementing this action is relatively simple with just a few steps.

1. Below is a working example of a typical release workflow using Action Tagger. Add this to a file called something like `action-release-workflow.yml`, and place it in the `.github/workflows/` folder. Token permissions have been scoped down to `contents:write` with support for pushing tags.

    ```yaml
    name: action-release-tags

    on:
      release:
        types: [released, edited]

    jobs:
      action-tagger:
        name: action-tagger
        runs-on: ubuntu-latest
        permissions:
          contents: write
        environment: releases

        steps:
        - uses: actions/checkout@v4
          with:
            # Disabling shallow clone ensures all commits 
            # and tags are available at checkout.
            fetch-depth: 0

        - name: Tag Release
          id: action-tagger
          uses: stevenjdh/action-tagger@v1
          with:
            set-latest-tag: true
    ```

2. When it's time to create a release, ensure that the tag being set is using the format `vX.X.X`. For example, `v1.2.3`. This will trigger the process and automate the rest.
3. Done. Feel free to edit the release if a mistake was made, and Action Tagger will reflect the changes for this as well.

> [!TIP]
> If using a release generator, define this action in that workflow and override the version used for processing with the generated one. This is needed because the release event will not be triggered due to [safeguards](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow#triggering-a-workflow-from-a-workflow) in the default GitHub token for preventing recursive workflow runs. Alternatively, use a [PAT](https://github.com/settings/tokens/new?scopes=workflow) with either `workflow` or `repo` scoped permissions, as PATs do not have the same limitations, except for the need to manage their expiration.

## Disclaimer
Action Tagger is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started [here](https://github.com/StevenJDH/.github/blob/main/docs/CONTRIBUTING.md).

## Do you have any questions?
Many commonly asked questions are answered in the FAQ:
[https://github.com/StevenJDH/action-tagger/wiki/FAQ](https://github.com/StevenJDH/action-tagger/wiki/FAQ)

## Want to show your support?

|Method          | Address                                                                                   |
|---------------:|:------------------------------------------------------------------------------------------|
|PayPal:         | [https://www.paypal.me/stevenjdh](https://www.paypal.me/stevenjdh "Steven's Paypal Page") |
|Cryptocurrency: | [Supported options](https://github.com/StevenJDH/StevenJDH/wiki/Donate-Cryptocurrency)    |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)