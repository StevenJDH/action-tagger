#!/bin/bash

# This file is part of Action Tagger <https://github.com/StevenJDH/action-tagger>.
# Copyright (C) 2024-2025 Steven Jenkins De Haro.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

if [[ "$INPUT_ENABLE_DRY_RUN" == "true" ]]; then
    echo "Preparing for dry-run..."
    INPUT_RELEASE_VERSION="refs/tags/v1.0.0"
    dry_run_flag="--dry-run"
elif [[ "$INPUT_RELEASE_VERSION" != "refs/tags/"* && "$INPUT_RELEASE_VERSION" == "refs/"*  ]]; then
    echo "::error::This should only run on push tags or on release if release-version is not used." >&2
    exit 1
fi

GITHUB_HOST=${GITHUB_SERVER_URL#https://}
REMOTE_URL=https://$INPUT_GITHUB_TOKEN@$GITHUB_HOST/$GITHUB_REPOSITORY

echo "Remote URL: $REMOTE_URL"

echo "Processing release version..."
RELEASE_TAG=${INPUT_RELEASE_VERSION/refs\/tags\//}
if ! [[ "$RELEASE_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "::error::Tag '$RELEASE_TAG' is not prefixed with a 'v' and or using semantic versioning." >&2
    exit 1
fi
MAJOR_VERSION=$(echo "$RELEASE_TAG" | cut -d. -f1)
MINOR_VERSION=$(echo "$RELEASE_TAG" | cut -d. -f2)

echo "Applying semantic tags [Dry Run: $INPUT_ENABLE_DRY_RUN]..."
if [[ "$INPUT_ENABLE_DRY_RUN" == "false" ]]; then
    git tag -f "$MAJOR_VERSION" "$RELEASE_TAG"
    git tag -f "$MAJOR_VERSION.$MINOR_VERSION" "$RELEASE_TAG"
    [[ "$INPUT_SET_LATEST_TAG" == "true" ]] && git tag -f latest "$RELEASE_TAG"
else
    # git tag doesn't support --dry-run so we simulate it.
    git tag -f "$MAJOR_VERSION"
    git tag -f "$MAJOR_VERSION.$MINOR_VERSION"
    [[ "$INPUT_SET_LATEST_TAG" == "true" ]] && git tag -f latest
fi
git push -f "$REMOTE_URL" --tags ${dry_run_flag:-}

cat <<EOF >> "$GITHUB_OUTPUT"
major_release=$MAJOR_VERSION
minor_release=$MAJOR_VERSION.$MINOR_VERSION
full_release=$RELEASE_TAG
latest_tag=$INPUT_SET_LATEST_TAG
EOF