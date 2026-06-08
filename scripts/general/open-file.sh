#!/bin/sh

# =============================================================================
# Script   : open-file.sh
# Purpose  : Interactively search and open files in the current directory
#            tree. Uses fzf for fuzzy selection with a bat-powered preview.
#            PDFs, .pages, and .numbers files are opened with the system
#            default application; all other files open in vim.
# Usage    : ./open-file.sh
# Requires : find, fzf, bat, file, vim, open (macOS)
# =============================================================================

set -eu

# --- Dependency check ---------------------------------------------------------

for cmd in find fzf bat file vim; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
    printf "Error: required command '%s' is not installed.\n" "$cmd" >&2
    exit 1
  fi
done

# --- Find files & excluding noisy directories ---------------------------------

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

# --- Exit cleanly if no file was selected -------------------------------------

[ -z "$file" ] && exit 0

# --- Determine how to open the selected file ----------------------------------

case "$file" in
  *.pdf | *.pages | *.numbers | *.jpg | *.jpeg | *.png | *.PNG)
    open "$file"
    exit 0
    ;;
esac

vim "$file"
