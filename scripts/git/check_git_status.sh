#!/usr/bin/env bash

# =============================================================================
# check_git_status.sh
# Description : Displays a formatted summary of the current git working tree.
# Usage       : bash check_git_status.sh
# Dependencies: git
# =============================================================================

set -euo pipefail

# -- Colors (only when stdout is a terminal) ----------------------------------

if [ -t 1 ]; then
    bold=$'\e[1m'
    dim=$'\e[2m'
    red=$'\e[38;5;167m'
    green=$'\e[38;5;108m'
    yellow=$'\e[38;5;144m'
    blue=$'\e[38;5;68m'
    reset=$'\e[0m'
else
    bold='' dim='' red='' green='' yellow='' blue='' reset=''
fi

separator="${dim}────────────────────────────────────────────────────────${reset}"

# -- Data collection ------------------------------------------------------------

staged_count=$(git diff --name-only --staged 2>/dev/null | wc -l | tr -d ' ')
unstaged_count=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
untracked_count=$(git ls-files --others --exclude-standard --directory 2>/dev/null | wc -l | tr -d ' ')

# -- Output -----------------------------------------------------------------------

# Staged
echo "${blue}${bold} Staged changes ($staged_count)${reset}"
if [ "$staged_count" -eq 0 ]; then
    echo "${dim}No staged changes${reset}"
else
    git --no-pager diff --staged --stat --color=always | sed 's/^/  /'
fi

# Unstaged
echo ""
echo "${yellow}${bold} Unstaged changes ($unstaged_count)${reset}"
if [ "$unstaged_count" -eq 0 ]; then
    echo "${dim}No unstaged changes${reset}"
else
    git --no-pager diff --stat --color=always | sed 's/^/  /'
fi

# Untracked
echo ""
echo "${green}${bold} Untracked files ($untracked_count)${reset}"
if [ "$untracked_count" -eq 0 ]; then
    echo "${dim}No untracked files${reset}"
else
    git ls-files --others --exclude-standard --directory \
        | sed "s|^|  ${red}?? |; s|\$|${reset}|"
fi

# Summary
echo ""
echo "$separator"
echo "${bold}Summary:${reset} ${blue}${staged_count} staged${reset}, ${yellow}${unstaged_count} unstaged${reset}, ${green}${untracked_count} untracked${reset}"
