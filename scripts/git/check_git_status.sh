#!/bin/sh

# =============================================================================
# check_git_status.sh
# Description : Displays a formatted summary of the current git working tree.
# Dependencies: git
# Usage       : ./check_git_status.sh
# =============================================================================

# -- Colors (only when stdout is a terminal) ----------------------------------

if [ -t 1 ]; then
  bold=$'\e[1m'   dim=$'\e[2m'
  red=$'\e[38;5;167m'  green=$'\e[38;5;108m'
  yellow=$'\e[38;5;144m' blue=$'\e[38;5;68m'
  reset=$'\e[0m'
else
  bold='' dim='' red='' green='' yellow='' blue='' reset=''
fi

# -- Helpers ------------------------------------------------------------------

# Count lines of output from a command
count_lines() { "$@" 2>/dev/null | wc -l | tr -d ' '; }

# Indent each line by two spaces
indent() { sed 's/^/  /'; }

SEPARATOR="${dim}────────────────────────────────────────────────────────${reset}"

# -- Data collection ----------------------------------------------------------

staged_count=$(count_lines   git diff --name-only --staged)
unstaged_count=$(count_lines git diff --name-only)
untracked_count=$(count_lines git ls-files --others --exclude-standard --directory)

# -- Output -------------------------------------------------------------------

# Staged
printf '%s Staged changes (%s)%s\n' "${blue}${bold}" "$staged_count" "$reset"
if [ "$staged_count" -eq 0 ]; then
  printf '%sNo staged changes%s\n' "$dim" "$reset"
else
  git --no-pager diff --staged --stat --color=always | indent
fi

# Unstaged
printf '\n%s Unstaged changes (%s)%s\n' "${yellow}${bold}" "$unstaged_count" "$reset"
if [ "$unstaged_count" -eq 0 ]; then
  printf '%sNo unstaged changes%s\n' "$dim" "$reset"
else
  git --no-pager diff --stat --color=always | indent
fi

# Untracked
printf '\n%s Untracked files (%s)%s\n' "${green}${bold}" "$untracked_count" "$reset"
if [ "$untracked_count" -eq 0 ]; then
  printf '%sNo untracked files%s\n' "$dim" "$reset"
else
  git ls-files --others --exclude-standard --directory \
    | sed "s|^|  ${red}?? |; s|$|${reset}|"
fi

# Summary
printf '\n%s\n' "$SEPARATOR"
printf '%sSummary:%s %s%s staged%s, %s%s unstaged%s, %s%s untracked%s\n' \
  "$bold" "$reset" \
  "$blue"   "$staged_count"   "$reset" \
  "$yellow" "$unstaged_count" "$reset" \
  "$green"  "$untracked_count" "$reset"