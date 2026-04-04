#!/bin/bash
# git-fuzzy-checkout
# Interactively checkout a git branch using fzf

set -euo pipefail

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a git repository."
    exit 1
fi

if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed. Please install it to use this script."
    exit 1
fi

get_branches() {
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    # List all local and remote branches, remove the current branch, and duplicates.
    git branch -a |
        sed 's/remotes\/origin\///' |
        sed 's/^\* //' |
        sed '/ -> /d' |
        grep -v -E "^${current_branch}$" |
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |
        sort |
        uniq
}

main() {
    echo "Fetching recent changes..."
    git fetch --quiet --all --prune

    local branch
    branch=$(get_branches | fzf)

    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    else
        echo "No branch selected."
    fi

    git pull --quiet
}

main
