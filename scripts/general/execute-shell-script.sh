#!/bin/sh

# =============================================================================
# Script   : execute-shell-script.sh
# Purpose  : Interactively browse and execute shell scripts in the current
#            directory tree using fzf for selection and bat for previewing.
# Usage    : ./execute-shell-script.sh
# Requires : fzf, bat, find, sh
# =============================================================================

set -euo pipefail

# --- Configuration ------------------------------------------------------------

EXCLUDED_DIRS=(
  "node_modules"
  ".idea"
  ".angular"
  "venv"
  "target"
  ".git"
)

# --- Dependency check ---------------------------------------------------------

for cmd in find fzf bat sh; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
    printf "Error: required command '%s' is not installed.\n" "$cmd" >&2
    exit 1
  fi
done

# --- Build the -prune expression ----------------------------------------------

prune_args=()
for dir in "${EXCLUDED_DIRS[@]}"; do
  prune_args+=(-name "$dir" -o)
done
# Remove the trailing -o
unset "prune_args[${#prune_args[@]}-1]"

# --- Find all .sh files -------------------------------------------------------

file=$(
  find . \
    -type d \( "${prune_args[@]}" \) -prune \
    -o -type f -name "*.sh" -print \
  | fzf \
      --height=85% \
      --prompt="Select a shell script to run: " \
      --preview="bat --color=always {}" \
      --preview-window=right:60%
)

# --- Execute selected script --------------------------------------------------

if [ -n "$file" ]; then
  printf "Running: %s\n" "$file"
  sh "$file"
else
  printf "No script selected.\n" >&2
  exit 0
fi