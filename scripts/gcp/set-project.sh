#!/usr/bin/env bash

# =============================================================================
# set-project.sh
# Description : Set the active gcloud project and billing quota project.
# Usage       : bash set-project.sh [PROJECT_ID]
#               bash set-project.sh -h
# Dependencies: gcloud
# =============================================================================

set -euo pipefail

# -- Help -------------------------------------------------------------------------

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    echo "Usage: $(basename "$0") [PROJECT_ID]"
    echo ""
    echo "Set the active gcloud project and billing quota project."
    echo "If PROJECT_ID is omitted, you will be prompted to enter one."
    exit 0
fi

# -- Preflight ------------------------------------------------------------------

if ! command -v gcloud >/dev/null 2>&1; then
    echo "Error: gcloud is required but not installed." >&2
    exit 1
fi

# -- Input ------------------------------------------------------------------------

project_id="${1:-}"

if [ -z "$project_id" ]; then
    echo -n "Enter GCP Project ID: "
    read -r project_id
fi

if [ -z "$project_id" ]; then
    echo "Error: No project ID provided." >&2
    exit 1
fi

# -- Validate project ID ------------------------------------------------------------

case "$project_id" in
    # GCP project IDs: 6-30 chars, lowercase letters, digits, hyphens;
    # must start with a letter and not end with a hyphen.
    [a-z][a-z0-9-]*[a-z0-9]) : ;;
    *)
        echo "Error: Invalid project ID '$project_id'. Must be 6–30 chars, start with a letter, use only lowercase letters, digits, and hyphens." >&2
        exit 1
        ;;
esac

project_id_len="${#project_id}"

if [ "$project_id_len" -lt 6 ] || [ "$project_id_len" -gt 30 ]; then
    echo "Error: Invalid project ID '$project_id'. Length must be between 6 and 30 characters." >&2
    exit 1
fi

# -- Apply ------------------------------------------------------------------------

if ! gcloud config set project "$project_id" --quiet; then
    echo "Error: Failed to set project." >&2
    exit 1
fi

if ! gcloud config set billing/quota_project "$project_id" --quiet; then
    echo "Error: Failed to set quota project." >&2
    exit 1
fi

echo "Project set to: $project_id"
