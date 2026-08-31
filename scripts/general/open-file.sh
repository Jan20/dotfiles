#!/usr/bin/env bash

# =============================================================================
# open-file.sh
# Description : Interactively search and open files in the current directory
#               tree. Uses fzf for fuzzy selection with a bat-powered preview.
#               PDFs, images and .numbers files open with the system default
#               application; .pages files open with Pages; everything else
#               opens in vim.
# Usage       : bash open-file.sh
# Dependencies: find, fzf, bat, vim, open (macOS)
# =============================================================================

set -euo pipefail

# -- Preflight --------------------------------------------------------------------

for cmd in find fzf bat vim; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' is not installed." >&2
    exit 1
  fi
done

# -- Find files, excluding noisy directories ---------------------------------------

file=$(
  find . \
    -type d \( \
      -name "node_modules" -o \
      -name ".idea"        -o \
      -name ".angular"     -o \
      -name "venv"         -o \
      -name "target"       -o \
      -name ".git"         \
    \) -prune \
    -o \( -type d -name "*.pages" -print -prune \) \
    -o -type f \
      ! -name "*.pyc"       \
      ! -name "__init__.py" \
      ! -name ".localized"  \
      ! -name ".DS_Store"   \
    -print \
  | fzf \
      --height=85% \
      --prompt="Select a file to open: " \
      --preview="bat --color=always {}" \
      --preview-window=right:60%
)

# -- Exit cleanly if no file was selected -------------------------------------------

if [ -z "$file" ]; then
  exit 0
fi

# -- Determine how to open the selected file ----------------------------------------

case "$file" in
  *.pages)
    open -a Pages "$file"
    exit 0
    ;;
  *.pdf | *.numbers | *.jpg | *.jpeg | *.png | *.PNG)
    open "$file"
    exit 0
    ;;
esac

vim "$file"
