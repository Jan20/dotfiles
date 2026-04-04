#!/usr/bin/env bash

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

indent() { sed 's/^/  /'; }

staged_count=$(git diff --name-only --staged 2>/dev/null | wc -l | tr -d ' ')
unstaged_count=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
untracked_count=$(git ls-files --others --exclude-standard --directory 2>/dev/null | wc -l | tr -d ' ')

printf '%s Staged changes (%s)%s\n' "${blue}${bold}" "${staged_count}" "${reset}"
if [ "$staged_count" -eq 0 ]; then
  printf '%sNo staged changes%s\n' "${dim}" "${reset}"
else
  git --no-pager diff --staged --stat --color=always | indent
fi

printf '\n%s Unstaged changes (%s)%s\n' "${yellow}${bold}" "${unstaged_count}" "${reset}"
if [ "$unstaged_count" -eq 0 ]; then
  printf '%sNo unstaged changes%s\n' "${dim}" "${reset}"
else
  git --no-pager diff --stat --color=always | indent
fi

printf '\n%s Untracked files (%s)%s\n' "${green}${bold}" "${untracked_count}" "${reset}"
if [ "$untracked_count" -eq 0 ]; then
  printf '%sNo untracked files%s\n' "${dim}" "${reset}"
else
  git ls-files --others --exclude-standard --directory | sed "s/^/  ${red}?? /"
fi

printf '\n%s────────────────────────────────────────────────────────%s\n' "${dim}" "${reset}"
printf '%sSummary: %s %s staged, %s %s unstaged, %s %s untracked%s\n' "${bold}" "${blue}" "${staged_count}" "${yellow}" "${unstaged_count}" "${green}" "${untracked_count}" "${reset}"
