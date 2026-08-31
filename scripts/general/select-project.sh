#!/usr/bin/env bash

# =============================================================================
# select-project.sh
# Description : Fuzzy-finds a directory under ~/Developer, previews its
#               contents, and changes into the selected directory.
# Usage       : . ./select-project.sh  (must be sourced to affect current shell)
# Dependencies: find, fzf, ls
# =============================================================================

search_root="${SEARCH_ROOT:-$HOME/Developer}"
max_depth=2

# -- Select directory -----------------------------------------------------------

directory=$(
    find "$search_root"          \
        -maxdepth "$max_depth"   \
        \( -name node_modules    \
        -o -name .git            \
        -o -name .idea           \
        -o -name .dist \) -prune \
        -o -type d -print        \
    | sed "s|^$search_root|.|"   \
    | fzf --preview="ls $search_root/{}"
)

if [ -z "$directory" ]; then
    echo "$PWD"
    return 1
fi

echo "${directory/#./$search_root}"
