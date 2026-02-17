#!/usr/bin/env bash

set -euo pipefail

for cmd in jq fzf npm; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing dependency: $cmd"
    exit 1
  }
done

if [[ ! -f package.json ]]; then
  echo "package.json not found"
  exit 1
fi

DEPS=$(
  jq -r '
    .dependencies // {} + .devDependencies // {}
    | keys[]
  ' package.json
)

if [[ -z "$DEPS" ]]; then
  echo "No dependencies found in package.json"
  exit 1
fi

SELECTED_DEP=$(echo "$DEPS" | sort | fzf --prompt="npm ls > ")

if [[ -z "$SELECTED_DEP" ]]; then
  exit 0
fi

echo "▶ npm ls $SELECTED_DEP"
npm ls "$SELECTED_DEP"
