#!/bin/bash

set -e

# Find files, exclude certain directories and files, pipe to fzf
file=$(find . \
  -type d \( -name node_modules -o -name .angular -o -name target -o -name .git \) -prune -o \
  -type f ! -name "*.png" ! -name ".localized" ! -name ".DS_Store" -print \
  | fzf --preview="bat --color=always {}")

# Checks whether a file is a pdf file and opens it with Preview
mime_type=$(file --mime-type --brief "$file")

if [ "$mime_type" = "application/pdf" ]; then
    open "$file"
    exit 0
fi

# If a file was selected, open it in Vim
if [ -n "$file" ]; then
  vim "$file"
fi
