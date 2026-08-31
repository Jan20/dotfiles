#!/usr/bin/env bash

# =============================================================================
# execute-shell-script.sh
# Description : Interactively browse and execute shell scripts in the current
#               directory tree using fzf for selection and bat for previewing.
# Usage       : bash execute-shell-script.sh
# Dependencies: find, fzf, bat, bash
# =============================================================================

set -euo pipefail

# -- Configuration --------------------------------------------------------------

excluded_dirs=(
  "node_modules"
  ".idea"
  ".angular"
  "venv"
  "target"
  ".git"
)

# -- Preflight --------------------------------------------------------------------

for cmd in find fzf bat bash; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' is not installed." >&2
    exit 1
  fi
done

# -- Build the -prune expression ----------------------------------------------------

prune_args=()
for dir in "${excluded_dirs[@]}"; do
  prune_args+=(-name "$dir" -o)
done
unset "prune_args[${#prune_args[@]}-1]"   # remove trailing -o

# -- Find all .sh files ---------------------------------------------------------------

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

# -- Execute selected script -----------------------------------------------------------

if [ -z "$file" ]; then
  echo "No script selected." >&2
  exit 0
fi

echo "Running: $file"
bash "$file"
