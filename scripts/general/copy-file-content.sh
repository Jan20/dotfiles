#!/bin/sh

# =============================================================================
# Script name : copy-file-content.sh
# Description : Select a file with fzf and copy its full content to the clipboard.
# Usage       : ./copy-file-content.sh
#               ./copy-file-content.sh /path/to/search/root
# Dependencies: find, fzf, pbcopy
# =============================================================================

set -eu

# -- Helpers -------------------------------------------------------------------

log_info() {
  printf "Info: %s\n" "$1"
}

die() {
  printf "Error: %s\n" "$1" >&2
  exit "${2:-1}"
}

# -- Dependency Checks ---------------------------------------------------------

command -v find >/dev/null 2>&1 || die "required command 'find' is not installed."
command -v fzf >/dev/null 2>&1 || die "required command 'fzf' is not installed."

# -- Input ---------------------------------------------------------------------

search_root="${1:-.}"

if [ ! -d "$search_root" ]; then
  die "'$search_root' is not a directory."
fi

# -- File Selection ------------------------------------------------------------

selected_file=$(
  find "$search_root" -maxdepth 4 -type f -print \
    | fzf --prompt="Select file to copy: "
)

if [ -z "$selected_file" ]; then
  exit 0
fi

# -- Copy Content --------------------------------------------------------------

pbcopy <"$selected_file"

log_info "copied content of '$selected_file' to clipboard."
