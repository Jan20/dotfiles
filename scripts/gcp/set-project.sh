#!/bin/sh

# =============================================================================
# set-project.sh
# Description : Prompts the user for a GCP project ID, then sets both the
#               active gcloud project and the billing quota project.
# Dependencies: gcloud
# Usage       : ./set-project.sh
# =============================================================================

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

command -v gcloud >/dev/null 2>&1 || die "gcloud is required but not installed."

printf "Enter GCP Project ID: "
read -r PROJECT_ID

[ -z "$PROJECT_ID" ] && die "No project ID provided."

gcloud config set project "$PROJECT_ID" || die "Failed to set project."
gcloud config set billing/quota_project "$PROJECT_ID" || die "Failed to set quota project."

echo "Project set to: $PROJECT_ID"
