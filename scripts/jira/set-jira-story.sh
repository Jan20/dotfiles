#!/usr/bin/env bash
# =============================================================================
# set-jira-story.sh
# Description : Fetches open Jira issues and sets JIRA_STORY to the selection.
# Usage       : source set-jira-story.sh
#               eval "$(bash set-jira-story.sh)"
# Environment : JIRA_DOMAIN, JIRA_USER, JIRA_TOKEN, JIRA_PROJECT
# Dependencies: curl, jq, fzf, column
# =============================================================================

set -euo pipefail

# -- Preflight -----------------------------------------------------------------

for cmd in curl jq fzf column; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

required_vars=(JIRA_DOMAIN JIRA_USER JIRA_TOKEN JIRA_PROJECT)
for var in "${required_vars[@]}"; do
    if [ -z "${!var:-}" ]; then
        echo "Error: $var is not set." >&2
        exit 1
    fi
done

# -- Configuration -------------------------------------------------------------

max_results=100

# -- Fetch issues --------------------------------------------------------------

if ! payload=$(jq -n \
    --arg project "$JIRA_PROJECT" \
    --argjson maxResults "$max_results" \
    '{
        jql: ("project = " + $project + " AND issuetype not in (Epic, Bug) AND statusCategory != Done ORDER BY updated DESC"),
        fields: ["summary", "status", "assignee"],
        maxResults: $maxResults
    }'
); then
    echo "Error: Failed to build request payload." >&2
    exit 1
fi

if ! response=$(curl \
    --silent \
    --fail-with-body \
    --request POST \
    --url "$JIRA_DOMAIN/rest/api/latest/search/jql" \
    --user "$JIRA_USER:$JIRA_TOKEN" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --data "$payload"
); then
    echo "Error: Jira API request failed." >&2
    echo "$response" >&2
    exit 1
fi

# -- Parse and select ----------------------------------------------------------

formatted=$(jq -r '
    .issues[] | [
        .key,
        (.fields.status.name // "—"),
        (.fields.assignee.displayName // "Unassigned"),
        .fields.summary
    ] | @tsv
' <<< "$response" | column -t -s $'\t')

if [ -z "$formatted" ]; then
    echo "No issues found for project $JIRA_PROJECT." >&2
    exit 0
fi

selection=$(echo "$formatted" | fzf \
    --prompt="Select story: " \
    --preview-window=up:6:wrap \
    --no-sort \
    --height=60% \
    --border || true)

if [ -z "$selection" ]; then
    exit 0
fi

# -- Export result -------------------------------------------------------------

read -r key _ <<< "$selection"

# Persist to .zshrc: replace existing line or append.
zshrc="${ZDOTDIR:-$HOME}/.zshrc"
if grep -q "^export JIRA_STORY=" "$zshrc" 2>/dev/null; then
    sed -i '' "s|^export JIRA_STORY=.*|export JIRA_STORY=$key|" "$zshrc"
else
    echo "export JIRA_STORY=$key" >> "$zshrc"
fi
echo "Jira Story $key has been selected." >&2

# When sourced, set directly; when executed, print for eval.
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    export JIRA_STORY="$key"
else
    echo "export JIRA_STORY=$key"
fi
