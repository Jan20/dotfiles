#!/bin/sh

# =============================================================================
# fuzzy-checkout.sh
# Description : Interactively select and check out a Git branch using fzf.
#               The script fetches/prunes remotes, shows local + origin branches
#               (deduplicated, excluding current branch), checks out selection,
#               then fast-forwards only when upstream is configured.
# Dependencies: git, fzf
# Usage       : ./fuzzy-checkout.sh
# =============================================================================

set -eu

# -----------------------------------------------------------------------------
# Preconditions
# -----------------------------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
  printf '%s\n' "Error: git is not installed." >&2
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  printf '%s\n' "Error: fzf is not installed." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf '%s\n' "Error: Not a git repository." >&2
  exit 1
fi

# -----------------------------------------------------------------------------
# Sync refs
# -----------------------------------------------------------------------------

printf '%s\n' "Fetching remote updates..."
git fetch --quiet --all --prune

# -----------------------------------------------------------------------------
# Build branch list
# -----------------------------------------------------------------------------

# Empty when detached HEAD; that's fine.
current_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || printf '')

# Use parseable refs instead of human-formatted `git branch -a`.
branches=$(
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin \
    | sed '/^origin\/HEAD$/d; s#^origin/##' \
    | awk 'NF && !seen[$0]++'
)

if [ -n "$current_branch" ]; then
  branches=$(printf '%s\n' "$branches" | grep -F -x -v "$current_branch" || true)
fi

if [ -z "$branches" ]; then
  printf '%s\n' "No branch available to select."
  exit 0
fi

# -----------------------------------------------------------------------------
# Select and checkout
# -----------------------------------------------------------------------------

branch=$(printf '%s\n' "$branches" | fzf --prompt='Checkout branch > ' --height=40% --reverse) || {
  printf '%s\n' "No branch selected."
  exit 0
}

[ -n "$branch" ] || {
  printf '%s\n' "No branch selected."
  exit 0
}

git checkout -- "$branch"

# -----------------------------------------------------------------------------
# Optional pull (safe mode)
# -----------------------------------------------------------------------------

# Pull only when on a branch that has an upstream configured.
if git symbolic-ref -q HEAD >/dev/null 2>&1 \
  && git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git pull --quiet --ff-only
fi