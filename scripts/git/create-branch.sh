#!/usr/bin/env bash

# =============================================================================
# create-branch.sh
# Description : Creates and switches to a new git branch prefixed with the
#               BRANCH_PREFIX environment variable.
# Usage       : BRANCH_PREFIX=feature bash create-branch.sh <branch-name>
#               BRANCH_PREFIX=feature bash create-branch.sh   (interactive)
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

# -- Branch name ----------------------------------------------------------------

branch_name="${1:-}"

if [ -z "$branch_name" ]; then
    read -rp "Branch name (prefixed with $BRANCH_PREFIX): " branch_name
fi

[ -n "$branch_name" ] || { echo "Error: branch name must not be empty." >&2; exit 1; }

full_branch_name="${BRANCH_PREFIX}-${branch_name}"

# -- Create & switch ------------------------------------------------------------

git switch -c "$full_branch_name"

echo "Switched to new branch '${full_branch_name}'"

