#!/bin/sh

# =============================================================================
# select-service-account.sh
# Description : Lists service accounts in the active GCP project, lets you
#               select one with fzf, and prints the IAM roles and permissions
#               granted to that account in the project.
# Usage       : ./select-service-account.sh
#               PROJECT_ID=my-project ./select-service-account.sh
# Dependencies: gcloud, fzf, jq, awk
# =============================================================================

set -eu

# -- Helpers ------------------------------------------------------------------

die() {
    printf 'Error: %s\n' "$1" >&2
    exit "${2:-1}"
}

log() {
    printf '%s\n' "$*"
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "$1 is required but not installed."
}

get_project_id() {
    project_id=${PROJECT_ID:-}

    if [ -n "$project_id" ]; then
        printf '%s\n' "$project_id"
        return 0
    fi

    project_id=$(gcloud config get-value project 2>/dev/null || printf '')
    [ -n "$project_id" ] && [ "$project_id" != "(unset)" ] || return 1

    printf '%s\n' "$project_id"
}

list_service_accounts() {
    gcloud iam service-accounts list --project="$1" --format=json
}

select_service_account() {
    printf '%s\n' "$1" |
        jq -r '.[] | [(.displayName // "-"), .email] | @tsv' |
        fzf --delimiter="$(printf '\t')" --with-nth=1,2 --prompt='Select service account: ' --height=40% --reverse
}

list_roles_for_member() {
    project_id=$1
    email=$2
    member="serviceAccount:$email"

    gcloud projects get-iam-policy "$project_id" --format=json |
        jq -r --arg member "$member" '.bindings[]? | select(.members[]? == $member) | .role' |
        awk '!seen[$0]++'
}

describe_role_permissions() {
    role=$1

    permissions_json=$(gcloud iam roles describe "$role" --format=json 2>/dev/null || printf '')
    [ -n "$permissions_json" ] || return 0

    printf '%s\n' "$permissions_json" |
        jq -r '.includedPermissions[]?' |
        awk '!seen[$0]++'
}

print_permissions_for_role() {
    role=$1
    permissions=$2

    printf '\nRole: %s\n' "$role"

    if [ -n "$permissions" ]; then
        printf '%s\n' "$permissions" | while IFS= read -r permission; do
            [ -n "$permission" ] || continue
            printf '  - %s\n' "$permission"
        done
        return 0
    fi

    printf '  (no permissions found or role could not be described)\n'
}

# -- Preconditions -------------------------------------------------------------

require_command gcloud
require_command fzf
require_command jq
require_command awk

if ! project_id=$(get_project_id); then
    die "No active GCP project. Set PROJECT_ID or run: gcloud config set project PROJECT_ID"
fi

# -- Main ---------------------------------------------------------------------

log "Fetching service accounts for project: $project_id..."
service_accounts=$(list_service_accounts "$project_id")

printf '%s\n' "$service_accounts" | jq -e '. | length > 0' >/dev/null 2>&1 || die "No service accounts found in project: $project_id"

selection=$(select_service_account "$service_accounts") || {
    log "No service account selected."
    exit 0
}

[ -n "$selection" ] || {
    log "No service account selected."
    exit 0
}

service_account_email=$(printf '%s\n' "$selection" | awk -F '\t' '{print $2}')
[ -n "$service_account_email" ] || die "Failed to read the selected service account email."

log "Inspecting IAM access for: $service_account_email"
roles=$(list_roles_for_member "$project_id" "$service_account_email")

[ -n "$roles" ] || {
    printf '\nNo project IAM roles found for %s.\n' "$service_account_email"
    exit 0
}

printf '\nService account: %s\nProject: %s\n' "$service_account_email" "$project_id"

printf '%s\n' "$roles" | while IFS= read -r role; do
    [ -n "$role" ] || continue
    permissions=$(describe_role_permissions "$role")
    print_permissions_for_role "$role" "$permissions"
done
