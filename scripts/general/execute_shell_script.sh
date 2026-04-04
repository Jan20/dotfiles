#!/bin/sh

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
  -type f -name '*.sh' \
  -print \
  | fzf --height=85% --prompt="Select a shell script to run: "  --preview="bat --color=always {}"
)

if [ -n "$file" ]; then
  echo "Running: $file"
  sh "$file"
else
  echo "No script selected."
fi
