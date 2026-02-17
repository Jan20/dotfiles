#!/bin/bash

set -e

file=$(find . \
  -type d \( -name node_modules -o -name .idea -o -name .angular -o -name venv -o -name target -o -name .git \) -prune -o \
  -type f ! -name "*.pyc" ! -name "*.png" ! -name ".localized" ! -name ".DS_Store" -print \
  | fzf --preview="bat --color=always {}")

mime_type=$(file --mime-type --brief "$file")

echo $mine_type

if [ "$mime_type" = "application/pdf" ]; then
    open "$file"
    exit 0
fi

if [[ "$file" == *.pages ]]; then
    open "$file"
    exit 0
fi

if [ -n "$file" ]; then
  vim "$file"
fi
