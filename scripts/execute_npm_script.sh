#!/usr/bin/env bash

set -e

# Ensure required tools exist
command -v jq >/dev/null 2>&1 || { echo "jq is required"; exit 1; }
command -v fzf >/dev/null 2>&1 || { echo "fzf is required"; exit 1; }

# Ensure package.json exists
if [[ ! -f package.json ]]; then
  echo "package.json not found"
  exit 1
fi

# Extract scripts as "name: command"
SCRIPTS=$(jq -r '.scripts | to_entries[] | "\(.key): \(.value)"' package.json)

if [[ -z "$SCRIPTS" ]]; then
  echo "No scripts found in package.json"
  exit 1
fi

# Select script via fzf
SELECTED=$(echo "$SCRIPTS" | fzf --prompt="npm script > ")

if [[ -z "$SELECTED" ]]; then
  exit 0
fi

# Extract script name (before colon)
SCRIPT_NAME="${SELECTED%%:*}"

echo "▶ Running: npm run $SCRIPT_NAME"
npm run "$SCRIPT_NAME"
