#!/usr/bin/env bash

# =============================================================================
# gcp-status.sh
# Description : Displays the current gcloud account, project, and quota project
#               with colour highlighting for known prefixes (e.g. qwiklabs).
# Usage       : bash gcp-status.sh
# Dependencies: gcloud
# =============================================================================

set -euo pipefail

# -- Configuration ----------------------------------------------------------------

account_prefix="student"
project_prefix="qwiklabs"

col_label_width=15
col_value_width=37
border="+------------------------------------------------------+"

green=$'\033[0;32m'
reset=$'\033[0m'

# -- Preflight ------------------------------------------------------------------

if ! command -v gcloud >/dev/null 2>&1; then
    echo "Error: gcloud is required but not installed." >&2
    exit 1
fi

# -- Fetch values -----------------------------------------------------------------

account=$(gcloud config get-value account 2>/dev/null || echo "N/A")
project=$(gcloud config get-value project 2>/dev/null || echo "N/A")
quota_project=$(gcloud config get-value billing/quota_project 2>/dev/null || echo "N/A")

# -- Print table ------------------------------------------------------------------

echo "$border"

for row in "GCloud User:|$account|$account_prefix" "GCP Project:|$project|$project_prefix" "Quota Project:|$quota_project|$project_prefix"; do
    IFS='|' read -r label value prefix <<< "$row"

    case "$value" in
        "$prefix"*) colored_value=$(printf "${green}%-${col_value_width}s${reset}" "$value") ;;
        *)          colored_value=$(printf "%-${col_value_width}s" "$value") ;;
    esac

    printf "| %-${col_label_width}s %s|\n" "$label" "$colored_value"
done

echo "$border"
