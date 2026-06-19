#!/bin/sh

# ----------------------------------------------------------------------------
# set-project.sh
# Description : Set the active gcloud project and billing quota project.
# Usage       : ./set-project.sh [PROJECT_ID]
#               ./set-project.sh -h
# Dependencies: gcloud
# ----------------------------------------------------------------------------

set -eu

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------

die() {
    printf 'Error: %s\n' "$1" >&2
    exit "${2:-1}"
}

usage() {
    printf 'Usage: %s [PROJECT_ID]\n' "$(basename "$0")"
    printf '\n'
    printf 'Set the active gcloud project and billing quota project.\n'
    printf 'If PROJECT_ID is omitted, you will be prompted to enter one.\n'
    exit 0
}

# ----------------------------------------------------------------------------
# Validation
# ----------------------------------------------------------------------------

command -v gcloud >/dev/null 2>&1 || die "gcloud is required but not installed."

validate_project_id() {
    case "$1" in
        # GCP project IDs: 6-30 chars, lowercase letters, digits, hyphens;
        # must start with a letter and not end with a hyphen.
        [a-z][a-z0-9-]*[a-z0-9]) : ;;
        *) die "Invalid project ID '$1'. Must be 6–30 chars, start with a letter, use only lowercase letters, digits, and hyphens." ;;
    esac

    len="${#1}"
    [ "$len" -ge 6 ] && [ "$len" -le 30 ] || \
        die "Invalid project ID '$1'. Length must be between 6 and 30 characters."
}

# ----------------------------------------------------------------------------
# Input
# ----------------------------------------------------------------------------

case "${1:-}" in
    -h|--help) usage ;;
esac

project_id="${1:-}"

if [ -z "$project_id" ]; then
    printf 'Enter GCP Project ID: '
    read -r project_id
fi

[ -n "$project_id" ] || die "No project ID provided."

validate_project_id "$project_id"

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------

gcloud config set project "$project_id" --quiet || die "Failed to set project."
gcloud config set billing/quota_project "$project_id" --quiet || die "Failed to set quota project."

printf 'Project set to: %s\n' "$project_id"
