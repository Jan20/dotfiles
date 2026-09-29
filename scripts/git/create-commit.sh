#!/usr/bin/env bash

# =============================================================================
# create-commit.sh
# Description : Creates a git commit prefixed with the branch's ticket ID
#               (e.g. branch "AI-413-add-login" -> commit "AI-413: <message>").
#               The branch name must start with the BRANCH_PREFIX environment
#               variable followed by an arbitrary number (e.g. "AI-413...").
# Usage       : BRANCH_PREFIX=AI bash create-commit.sh "Add login form"
#               BRANCH_PREFIX=AI bash create-commit.sh   (interactive)
# Dependencies: git
# =============================================================================

set -euo pipefail

# -- Validation ---------------------------------------------------------------

if [ -z "${BRANCH_PREFIX:-}" ]; then
    echo "Error: BRANCH_PREFIX environment variable is not set." >&2
    exit 1
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || { echo "Error: not inside a git repository." >&2; exit 1; }

# -- Derive prefix from branch name -----------------------------------------------

branch_name=$(git rev-parse --abbrev-ref HEAD)
branch_prefix=$(echo "$branch_name" | grep -oE "^${BRANCH_PREFIX}-[0-9]+" || true)

if [ -z "$branch_prefix" ]; then
    echo "Error: branch '${branch_name}' does not start with '${BRANCH_PREFIX}' followed by a number." >&2
    exit 1
fi

# -- Commit message -------------------------------------------------------------

commit_message="${1:-}"

if [ -z "$commit_message" ]; then
    read -rp "Commit message: " commit_message
fi

[ -n "$commit_message" ] || { echo "Error: commit message must not be empty." >&2; exit 1; }

# -- Commit -----------------------------------------------------------------------

git commit -m "${branch_prefix}: ${commit_message}"

