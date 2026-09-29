#!/usr/bin/env bash

# =============================================================================
# select-service-account.sh
# Description : Lists service accounts in the active GCP project, lets you
#               select one with fzf, and prints the IAM roles and permissions
#               granted to that account in the project.
# Usage       : bash select-service-account.sh
#               PROJECT_ID=my-project bash select-service-account.sh
# Dependencies: gcloud, fzf, jq
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

for cmd in gcloud fzf jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

project_id="${PROJECT_ID:-}"

if [ -z "$project_id" ]; then
    project_id=$(gcloud config get-value project 2>/dev/null || true)
fi

if [ -z "$project_id" ] || [ "$project_id" = "(unset)" ]; then
    echo "Error: No active GCP project. Set PROJECT_ID or run: gcloud config set project PROJECT_ID" >&2
    exit 1
fi

# -- List service accounts --------------------------------------------------------

echo "Fetching service accounts for project: $project_id..."
service_accounts=$(gcloud iam service-accounts list --project="$project_id" --format=json)

if [ "$(echo "$service_accounts" | jq 'length')" -eq 0 ]; then
    echo "Error: No service accounts found in project: $project_id" >&2
    exit 1
fi

selection=$(
    echo "$service_accounts" \
    | jq -r '.[] | [(.displayName // "-"), .email] | @tsv' \
    | fzf --delimiter=$'\t' --with-nth=1,2 --prompt="Select service account: " --height=40% --reverse \
    || true
)

if [ -z "$selection" ]; then
    echo "No service account selected."
    exit 0
fi

service_account_email=$(cut -f2 <<< "$selection")

if [ -z "$service_account_email" ]; then
    echo "Error: Failed to read the selected service account email." >&2
    exit 1
fi

# -- Inspect IAM roles --------------------------------------------------------------

echo "Inspecting IAM access for: $service_account_email"

member="serviceAccount:$service_account_email"
roles=$(
    gcloud projects get-iam-policy "$project_id" --format=json \
    | jq -r --arg member "$member" '.bindings[]? | select(.members[]? == $member) | .role' \
    | sort -u
)

if [ -z "$roles" ]; then
    echo ""
    echo "No project IAM roles found for $service_account_email."
    exit 0
fi

echo ""
echo "Service account: $service_account_email"
echo "Project: $project_id"

while IFS= read -r role; do
    [ -n "$role" ] || continue

    echo ""
    echo "Role: $role"

    permissions=$(gcloud iam roles describe "$role" --format=json 2>/dev/null | jq -r '.includedPermissions[]?' | sort -u || true)

    if [ -z "$permissions" ]; then
        echo "  (no permissions found or role could not be described)"
        continue
    fi

    while IFS= read -r permission; do
        [ -n "$permission" ] || continue
        echo "  - $permission"
    done <<< "$permissions"
done <<< "$roles"
