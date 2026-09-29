#!/usr/bin/env bash

# =============================================================================
# search.sh
# Description : Searches file contents for a term (excluding node_modules),
#               previews matches with bat, and opens the selection in vim.
# Usage       : bash search.sh
# Dependencies: grep, fzf, bat, vim
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

for cmd in grep fzf bat vim; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

# -- Search and select --------------------------------------------------------------

echo -n "Enter the search term: "
read -r search_term

selected_file=$(grep -rl --exclude-dir=node_modules "$search_term" . | fzf --preview="bat --color=always {}" || true)

if [ -z "$selected_file" ]; then
    echo "No file selected or no match found."
    exit 0
fi

vim "$selected_file"

