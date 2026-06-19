#!/bin/sh

# =============================================================================
# cloudrun-logs.sh
# Description : Interactively select a Cloud Run service and tail its logs.
#               Uses the active gcloud project from config unless overridden.
#               Queries Cloud Logging for recent Cloud Run revision entries.
# Dependencies: gcloud, fzf
# Usage       : ./cloudrun-logs.sh
# =============================================================================

set -eu

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

die() {
  printf '%s\n' "Error: $*" >&2
  exit 1
}

# -----------------------------------------------------------------------------
# Preconditions
# -----------------------------------------------------------------------------

command -v gcloud >/dev/null 2>&1 || die "gcloud is not installed or not on PATH."
command -v fzf    >/dev/null 2>&1 || die "fzf is not installed. Install with: brew install fzf"

project=$(gcloud config get-value project 2>/dev/null || true)

[ -n "$project" ] && [ "$project" != "(unset)" ] \
  || die "No active GCP project. Run: gcloud config set project PROJECT_ID"

# -----------------------------------------------------------------------------
# Service selection
# -----------------------------------------------------------------------------

printf '%s\n' "Fetching Cloud Run services for project: $project..."

services=$(gcloud run services list --project="$project" --format='value(name)' 2>/dev/null || true)

[ -n "$services" ] || die "No Cloud Run services found in project: $project"

service=$(printf '%s\n' "$services" | fzf --prompt='Select Cloud Run service: ' --height=40% --reverse) || {
  printf '%s\n' "No service selected."
  exit 0
}

# -----------------------------------------------------------------------------
# Log retrieval
# -----------------------------------------------------------------------------

printf '%s\n' "Fetching logs for service: $service..."

gcloud logging read \
  "resource.type=cloud_run_revision AND resource.labels.service_name=\"$service\"" \
  --project="$project" \
  --limit=100 \
  --order=desc \
  --format='table(timestamp, severity, textPayload)'