#!/usr/bin/env bash
# =============================================================================
# show-jira-stories.sh
# Description : Fetches open Jira issues for a project, presents them via fzf,
#               and opens the selected issue in the browser.
# Usage       : bash show-jira-stories.sh
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
    echo "No issues found for project $JIRA_PROJECT."
    exit 0
fi

selection=$(echo "$formatted" | fzf \
    --prompt="Select issue: " \
    --preview-window=up:7:wrap \
    --no-sort \
    --height=60% \
    --border || true)

if [ -z "$selection" ]; then
    exit 0
fi

# -- Open in browser -----------------------------------------------------------

read -r key _ <<< "$selection"
url="$JIRA_DOMAIN/browse/$key"

echo "Opening $url..."
open "$url"
