#!/usr/bin/env bash
# =============================================================================
# set-state.sh
# Description : Transitions the current JIRA_STORY to a state selected via fzf.
# Usage       : bash set-state.sh
# Environment : JIRA_DOMAIN, JIRA_USER, JIRA_TOKEN, JIRA_STORY
# Dependencies: curl, jq, fzf
# =============================================================================

set -euo pipefail

# -- Preflight -----------------------------------------------------------------

for cmd in curl jq fzf; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

required_vars=(JIRA_DOMAIN JIRA_USER JIRA_TOKEN JIRA_STORY)
for var in "${required_vars[@]}"; do
    if [ -z "${!var:-}" ]; then
        echo "Error: $var is not set." >&2
        exit 1
    fi
done

# -- Fetch available transitions -----------------------------------------------

if ! transitions_response=$(curl \
    --silent \
    --fail-with-body \
    --request GET \
    --url "$JIRA_DOMAIN/rest/api/latest/issue/$JIRA_STORY/transitions" \
    --user "$JIRA_USER:$JIRA_TOKEN" \
    --header "Accept: application/json"
); then
    echo "Error: Failed to fetch transitions for $JIRA_STORY." >&2
    echo "$transitions_response" >&2
    exit 1
fi

# -- Select transition ---------------------------------------------------------

selection=$(jq -r '.transitions[] | "\(.id)\t\(.name)"' <<< "$transitions_response" \
    | fzf \
        --prompt="Transition $JIRA_STORY to: " \
        --with-nth=2.. \
        --height=40% \
        --border \
    || true)

if [ -z "$selection" ]; then
    exit 0
fi

transition_id=$(cut -f1 <<< "$selection")
target_status=$(cut -f2 <<< "$selection")

# -- Apply transition ----------------------------------------------------------

payload=$(jq -n --arg id "$transition_id" '{ transition: { id: $id } }')

if ! transition_response=$(curl \
    --silent \
    --fail-with-body \
    --request POST \
    --url "$JIRA_DOMAIN/rest/api/latest/issue/$JIRA_STORY/transitions" \
    --user "$JIRA_USER:$JIRA_TOKEN" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --data "$payload"
); then
    echo "Error: Failed to apply transition." >&2
    echo "$transition_response" >&2
    exit 1
fi

echo "$JIRA_STORY → $target_status"
