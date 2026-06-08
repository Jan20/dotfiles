#!/bin/bash

# =============================================================================
# show-jira-story.sh
# Description : Fetches open Jira issues for a project, presents them via fzf,
#               and opens the selected issue in the browser.
# Dependencies: curl, jq, fzf
# Usage       : sh show-jira-story.sh
# Environment : JIRA_DOMAIN, JIRA_USER, JIRA_TOKEN, JIRA_PROJECT
# =============================================================================

# -- Configuration ------------------------------------------------------------

JIRA_DOMAIN="${JIRA_DOMAIN}"
JIRA_USER="${JIRA_USER}"
JIRA_TOKEN="${JIRA_TOKEN}"
JIRA_PROJECT="${JIRA_PROJECT}"

ISSUE_FIELDS='["summary", "status", "assignee"]'
JQL="project = ${JIRA_PROJECT} AND issuetype not in (Epic, Bug) AND statusCategory != Done"

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# -- Preflight ----------------------------------------------------------------

command -v curl >/dev/null 2>&1 || die "curl is required but not installed."
command -v jq   >/dev/null 2>&1 || die "jq is required but not installed."
command -v fzf  >/dev/null 2>&1 || die "fzf is required but not installed."

[ -n "$JIRA_DOMAIN"  ] || die "JIRA_DOMAIN is not set."
[ -n "$JIRA_USER"    ] || die "JIRA_USER is not set."
[ -n "$JIRA_TOKEN"   ] || die "JIRA_TOKEN is not set."
[ -n "$JIRA_PROJECT" ] || die "JIRA_PROJECT is not set."

# -- Fetch issues -------------------------------------------------------------

PAYLOAD=$(jq -n \
    --arg jql    "$JQL"          \
    --argjson fields "$ISSUE_FIELDS" \
    '{ jql: $jql, fields: $fields }'
)

RESPONSE=$(curl \
    --silent \
    --fail \
    --request POST \
    --url "$JIRA_DOMAIN/rest/api/latest/search/jql" \
    --user "$JIRA_USER:$JIRA_TOKEN" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --data "$PAYLOAD"
) || die "Jira API request failed."

# -- Parse and select ---------------------------------------------------------

SELECTION=$(
    echo "$RESPONSE" \
    | jq -r '.issues[] | "\(.key): \(.fields.summary)"' \
    | fzf --prompt="Select issue: " --preview="echo {}"
)

[ -z "$SELECTION" ] && exit 0

# -- Open in browser ----------------------------------------------------------

KEY=$(echo "$SELECTION" | cut -d: -f1)
URL="$JIRA_DOMAIN/browse/$KEY"

echo "Opening $URL..."
open "$URL"
