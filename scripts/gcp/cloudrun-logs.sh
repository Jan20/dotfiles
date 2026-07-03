#!/bin/sh

# =============================================================================
# cloudrun-logs.sh
# Selects a Cloud Run service interactively and streams matching Cloud Logging
# entries for that service.
#
# Usage:
#   ./cloudrun-logs.sh
#   PROJECT_ID=my-project ./cloudrun-logs.sh
#
# Dependencies:
#   gcloud
#   fzf
# =============================================================================

# =============================================================================
# -- Helpers ------------------------------------------------------------------

die() {
    printf '%s\n' "Error: $*" >&2
    exit 1
}

log() {
    printf '%s\n' "$*"
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "$1 is not installed or not on PATH."
}

set -eu

# -- Preconditions -------------------------------------------------------------

require_command gcloud
require_command fzf

project_id=${PROJECT_ID:-}

if [ -z "$project_id" ]; then
    project_id=$(gcloud config get-value project 2>/dev/null || true)
fi

[ -n "$project_id" ] && [ "$project_id" != "(unset)" ] || {
    die "No active GCP project. Set PROJECT_ID or run: gcloud config set project PROJECT_ID"
}

# -- Service selection ---------------------------------------------------------

log "Fetching Cloud Run services for project: $project_id..."

services=$(gcloud run services list --project="$project_id" --format='value(name)' 2>/dev/null || true)

[ -n "$services" ] || die "No Cloud Run services found in project: $project_id"

service=$(printf '%s\n' "$services" | fzf --prompt='Select Cloud Run service: ' --height=40% --reverse) || {
    log "No service selected."
    exit 0
}

# -- Log retrieval -------------------------------------------------------------

log "Fetching logs for service: $service..."

gcloud logging read \
    "resource.type=cloud_run_revision AND resource.labels.service_name=\"$service\"" \
    --project="$project_id" \
    --limit=100 \
    --order=desc \
    --format='table(timestamp, severity, textPayload)'