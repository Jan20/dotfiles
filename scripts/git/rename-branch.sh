#!/usr/bin/env bash

# =============================================================================
# rename-branch.sh
# Description : Renames the current git branch and pushes the new name to
#               origin, removing the old remote branch. The new branch name
#               is always "${BRANCH_PREFIX}-<number>-<name>"; only provide the
#               <number>-<name> part (e.g. BRANCH_PREFIX="AI" -> "413-add-login"
#               becomes "AI-413-add-login").
# Usage       : BRANCH_PREFIX=AI bash rename-branch.sh 413-add-login
#               BRANCH_PREFIX=AI bash rename-branch.sh   (interactive)
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

# -- New branch name --------------------------------------------------------------

branch_suffix="${1:-}"

if [ -z "$branch_suffix" ]; then
    read -rp "New branch name (<number>-<name>, e.g. 413-add-login): " branch_suffix
fi

[ -n "$branch_suffix" ] || { echo "Error: branch name must not be empty." >&2; exit 1; }

echo "$branch_suffix" | grep -E -q "^[0-9]+" \
    || { echo "Error: branch name must start with a number." >&2; exit 1; }

new_branch_name="${BRANCH_PREFIX}-${branch_suffix}"

old_branch_name=$(git rev-parse --abbrev-ref HEAD)

if [ "$old_branch_name" = "$new_branch_name" ]; then
    echo "Error: new branch name is the same as the current branch name." >&2
    exit 1
fi

# -- Rename locally ---------------------------------------------------------------

git branch -m "$new_branch_name"

# -- Push new name & remove old remote branch --------------------------------------

git push origin -u "$new_branch_name"

if git ls-remote --exit-code --heads origin "$old_branch_name" >/dev/null 2>&1; then
    git push origin --delete "$old_branch_name"
fi

echo "Renamed branch '${old_branch_name}' to '${new_branch_name}' and updated origin."

