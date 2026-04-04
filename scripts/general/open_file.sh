#!/bin/bash
# This script is an interactive file search and open utility.
# It uses find to list files in the current directory—ignoring
# noisy directories (like node_modules or .git) and binary/hidden
# files—and pipes the results into fzf for fuzzy selection with a
# syntax-highlighted preview using bat.

set -euo pipefail

file=$(find . \
  -type d \( \
    -name node_modules -o \
    -name .idea -o \
    -name .angular -o \
    -name venv -o \
    -name target -o \
    -name .git \
  \) -prune -o \
  -type f \
    ! -name "*.pyc" \
    ! -name "*.png" \
    ! -name "__init__.py" \
    ! -name ".localized" \
    ! -name ".DS_Store" \
  -print \
  | fzf --height="85%" --preview="bat --color=always {}")


if [ -z "$file" ]; then
  exit 0
fi

mime_type=$(file --mime-type --brief "$file")

if [ "$mime_type" = "application/pdf" ] || [[ "$file" == *.pages ]]; then
    open "$file"
    exit 0
fi

vim "$file"
