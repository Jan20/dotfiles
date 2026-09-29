#!/usr/bin/env bash

# =============================================================================
# select-dir.sh
# Description : Fuzzy-finds a sub-directory under the current working directory,
#               previews its contents or README, and changes into it.
# Usage       : . ./select-dir.sh  (must be sourced to affect current shell)
# Dependencies: find, fzf
# =============================================================================

max_depth=5

# -- Preflight ----------------------------------------------------------------

if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is required but not installed." >&2
    return 1
fi

# -- Select directory -----------------------------------------------------------

directory=$(
    find .                              \
        -maxdepth "$max_depth"          \
        \( -name node_modules           \
        -o -name .git                   \
        -o -name tools \) -prune        \
        -o \( -name "*.numbers"         \
        -o -name "*.pages" \)           \
        -print -prune                   \
        -o -type d -print               \
    | sed 's|^\./||'                    \
    | fzf --preview="[ -f {}/README.md ] && cat {}/README.md || ls --color=always {}"
)

if [ -z "$directory" ]; then
    echo .
elif printf '%s\n' "$directory" | grep -qE '\.(numbers|pages)$'; then
    open "$directory"
    echo .
else
    echo "$directory"
fi
