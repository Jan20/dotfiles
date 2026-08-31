#!/usr/bin/env bash

# =============================================================================
# copy-file-content.sh
# Description : Select a file with fzf and copy its full content to the clipboard.
# Usage       : bash copy-file-content.sh
#               bash copy-file-content.sh /path/to/search/root
# Dependencies: find, fzf, pbcopy
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

if ! command -v find >/dev/null 2>&1; then
    echo "Error: find is required but not installed." >&2
    exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is required but not installed." >&2
    exit 1
fi

search_root="${1:-.}"

if [ ! -d "$search_root" ]; then
    echo "Error: '$search_root' is not a directory." >&2
    exit 1
fi

# -- File selection ---------------------------------------------------------------

selected_file=$(find "$search_root" -maxdepth 4 -type f -print | fzf --prompt="Select file to copy: ")

if [ -z "$selected_file" ]; then
    exit 0
fi

# -- Copy content -------------------------------------------------------------------

pbcopy < "$selected_file"

echo "Info: copied content of '$selected_file' to clipboard."
