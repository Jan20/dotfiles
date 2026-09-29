#!/usr/bin/env bash

# =============================================================================
# execute_npm_script.sh
# Description : Interactively selects and runs an npm script from package.json.
# Usage       : bash execute_npm_script.sh
# Dependencies: jq, fzf, npm
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required but not installed." >&2
    exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is required but not installed." >&2
    exit 1
fi

if [ ! -f package.json ]; then
    echo "Error: package.json not found." >&2
    exit 1
fi

# -- List scripts -----------------------------------------------------------------

scripts=$(jq -r '.scripts | to_entries[] | "\(.key): \(.value)"' package.json)

if [ -z "$scripts" ]; then
    echo "Error: No scripts found in package.json." >&2
    exit 1
fi

# -- Select and run -----------------------------------------------------------------

selected=$(echo "$scripts" | fzf --prompt="npm script > ")

if [ -z "$selected" ]; then
    exit 0
fi

script_name="${selected%%:*}"

echo "▶ Running: npm run $script_name"
npm run "$script_name"
