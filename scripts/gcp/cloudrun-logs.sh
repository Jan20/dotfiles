#!/usr/bin/env bash

# =============================================================================
# cloudrun-logs.sh
# Description : Selects a Cloud Run service interactively and streams matching
#               Cloud Logging entries for that service.
# Usage       : bash cloudrun-logs.sh
#               PROJECT_ID=my-project bash cloudrun-logs.sh
# Dependencies: gcloud, fzf
# =============================================================================

set -euo pipefail

# -- Preflight ------------------------------------------------------------------

for cmd in gcloud fzf; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed or not on PATH." >&2
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

# -- Service selection ------------------------------------------------------------

echo "Fetching Cloud Run services for project: $project_id..."

services=$(gcloud run services list --project="$project_id" --format="value(name)" 2>/dev/null || true)

if [ -z "$services" ]; then
    echo "Error: No Cloud Run services found in project: $project_id" >&2
    exit 1
fi

service=$(echo "$services" | fzf --prompt="Select Cloud Run service: " --height=40% --reverse || true)

if [ -z "$service" ]; then
    echo "No service selected."
    exit 0
fi

# -- Log retrieval ------------------------------------------------------------------

echo "Fetching logs for service: $service..."

gcloud logging read \
    "resource.type=cloud_run_revision AND resource.labels.service_name=\"$service\"" \
    --project="$project_id" \
    --limit=100 \
    --order=desc \
    --format="table(timestamp, severity, textPayload)"
