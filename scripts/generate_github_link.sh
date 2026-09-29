#!/usr/bin/env bash

# =============================================================================
# generate_github_link.sh
# Description : Opens a Git-tracked file on GitHub in the browser at the
#               current branch. Must be sourced so `return` works correctly.
# Usage       : source generate_github_link.sh
# Dependencies: git, fzf, open (macOS)
# =============================================================================

# -- Preflight ------------------------------------------------------------------

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not inside a Git repository." >&2
    return 1
fi

# -- Resolve GitHub URL -----------------------------------------------------------

remote_url=$(git config --get remote.origin.url)

if [[ "$remote_url" == git@github.com:* ]]; then
    remote_url="https://github.com/${remote_url#git@github.com:}"
    remote_url="${remote_url%.git}"
elif [[ "$remote_url" == https://github.com/* ]]; then
    remote_url="${remote_url%.git}"
else
    echo "Error: Remote URL is not a GitHub repository." >&2
    return 1
fi

# -- Select file --------------------------------------------------------------------

selected_file=$(git ls-files | fzf --prompt="Select a file: ")

if [ -z "$selected_file" ]; then
    echo "No file selected." >&2
    return 1
fi

# -- Open in browser ------------------------------------------------------------------

branch_name=$(git rev-parse --abbrev-ref HEAD)

open "$remote_url/blob/$branch_name/$selected_file"
