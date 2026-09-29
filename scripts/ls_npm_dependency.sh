#!/usr/bin/env bash

# =============================================================================
# ls_npm_dependency.sh
# Description : Interactively selects a dependency from package.json and runs
#               `npm ls` against it.
# Usage       : bash ls_npm_dependency.sh
# Dependencies: jq, fzf, npm
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

for cmd in jq fzf npm; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

if [ ! -f package.json ]; then
    echo "Error: package.json not found." >&2
    exit 1
fi

# -- List dependencies --------------------------------------------------------------

deps=$(jq -r '.dependencies // {} + .devDependencies // {} | keys[]' package.json)

if [ -z "$deps" ]; then
    echo "Error: No dependencies found in package.json." >&2
    exit 1
fi

# -- Select and inspect ---------------------------------------------------------------

selected_dep=$(echo "$deps" | sort | fzf --prompt="npm ls > ")

if [ -z "$selected_dep" ]; then
    exit 0
fi

echo "▶ npm ls $selected_dep"
npm ls "$selected_dep"
