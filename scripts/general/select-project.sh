#!/bin/sh

# =============================================================================
# select-project.sh
# Description : Fuzzy-finds a directory under ~/Developer, previews its
#               contents, and changes into the selected directory.
# Dependencies: find, fzf, ls
# Usage       : . ./select-project.sh  (must be sourced to affect current shell)
# =============================================================================

# -- Configuration ------------------------------------------------------------

SEARCH_ROOT="${SEARCH_ROOT:-$HOME/Developer}"
MAX_DEPTH=3

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    return "${2:-1}"
}

# -- Main ---------------------------------------------------------------------

DIRECTORY=$(
    find "$SEARCH_ROOT"             \
        -maxdepth "$MAX_DEPTH"      \
        \( -name node_modules       \
        -o -name .git               \
        -o -name .idea              \
        -o -name .dist              \
        -o -name tools \) -prune    \
        -o -type d -print           \
    | fzf --preview="[ -f {}/README.md ] && cat {}/README.md || ls --color=always {}"
)

[ -z "$DIRECTORY" ] && die "No directory selected."

echo $DIRECTORY