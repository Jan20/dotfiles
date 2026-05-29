#!/bin/sh

# =============================================================================
# select-subdir.sh
# Description : Fuzzy-finds a sub-directory under the current working directory,
#               previews its contents or README, and changes into it.
# Dependencies: find, fzf
# Usage       : . ./select-subdir.sh  (must be sourced to affect current shell)
# =============================================================================

# -- Configuration ------------------------------------------------------------

MAX_DEPTH=5

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    return "${2:-1}"
}

# -- Preflight ----------------------------------------------------------------

command -v fzf >/dev/null 2>&1 || die "fzf is required but not installed."

# -- Main ---------------------------------------------------------------------

DIRECTORY=$(
    find .                          \
        -maxdepth "$MAX_DEPTH"      \
        \( -name node_modules       \
        -o -name .git               \
        -o -name tools \) -prune    \
        -o -type d -print           \
    | sed 's|^\./||'                \
    | fzf --preview="[ -f {}/README.md ] && cat {}/README.md || ls --color=always {}"
)

[ -z "$DIRECTORY" ] && echo .

echo $DIRECTORY
