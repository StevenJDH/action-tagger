# Action Tagger

[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat&logo=ubuntu&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![macOS](https://img.shields.io/badge/macOS-000000?style=flat\&logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat\&logo=windows\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)

[![build](https://github.com/StevenJDH/action-tagger/actions/workflows/bash-action-workflow.yml/badge.svg?branch=main)](https://github.com/StevenJDH/action-tagger/actions/workflows/bash-action-workflow.yml)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/StevenJDH/action-tagger?include_prereleases)
[![Public workflows that use this action.](https://img.shields.io/endpoint?style=flat&url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3DStevenJDH%2Faction-tagger%26badge%3Dtrue)](https://github.com/search?o=desc&q=StevenJDH+action-tagger+language%3AYAML&s=&type=Code)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a8ae369daa344226b27d34db9c1ae9ef)](https://app.codacy.com/gh/StevenJDH/action-tagger/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
![Maintenance](https://img.shields.io/badge/yes-4FCA21?label=maintained&style=flat)
![GitHub](https://img.shields.io/github/license/StevenJDH/action-tagger)

Action Tagger automatically sets semantic tags when releasing a new version of a GitHub action. This action adheres to GitHub's [action versioning guide](https://github.com/actions/toolkit/blob/master/docs/action-versioning.md#versioning), and removes the tedious task of having to manually set and shift tags like `v1` and `v1.2` to ensure they always point to newer releases. Optionally, an additional `latest` tag can be set so that the latest release can be used instead of pointing to `main` directly.

---

[![Buy me a coffee](https://img.shields.io/static/v1?label=Buy%20me%20a&message=coffee&color=important&style=flat&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/stevenjdh)

## Inputs
The following inputs are available:

| Name                                                                         | Type     | Required | Default                         |  Description                                                        |
|------------------------------------------------------------------------------|----------|:--------:|:-------------------------------:|---------------------------------------------------------------------|
| <a name="enable-dry-run"></a>[enable&#x2011;dry&#x2011;run](#enable-dry-run) | `string` | `false`  | `false`                         | Indicates whether or not to perform a dry run without pushing tags. |
| <a name="set-latest-tag"></a>[set&#x2011;latest&#x2011;tag](#set-latest-tag) | `string` | `false`  | `false`                         | Indicates whether or not to also set the latest tag.                |
| <a name="github-token"></a>[github&#x2011;token](#github-token)              | `string` | `false`  | <pre>${{&#xa0;github.token&#xa0;}}</pre> | Overrides the default GitHub token used to authenticate against a repository for Git context. |

> [!NOTE]  
> Enabling dry-run will use a dummy version of v1.0.0 regardless of what version tags are available.

## Outputs
The following outputs are available:

| Name                                                        | Type     | Example | Description                                      |
|-------------------------------------------------------------|----------|---------|--------------------------------------------------|
| <a name="major_release"></a>[major_release](#major_release) | `string` | v1      | The latest major release version.                |
| <a name="minor_release"></a>[minor_release](#minor_release) | `string` | v1.2    | The latest major and feature release version.    |
| <a name="full_release"></a>[full_release](#full_release)    | `string` | v1.2.3  | The full release version.                        |
| <a name="latest_tag"></a>[latest_tag](#latest_tag)          | `string` | false   | Indicates whether of not the latest tag was set. |

## Usage
Below is a working example of a typical release workflow using Action Tagger. Token permissions have been scoped down to `contents:write` with support for pushing tags.

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