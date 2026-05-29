#!/bin/bash
set -euo pipefail

if ! command -v gcloud &>/dev/null; then
  echo "Error: gcloud is not installed or not on PATH." >&2
  exit 1
fi

if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is not installed. Install with: brew install fzf" >&2
  exit 1
fi

project=$(gcloud config get-value project 2>/dev/null)
if [[ -z "$project" ]]; then
  echo "Error: No active GCP project set. Run: gcloud config set project PROJECT_ID" >&2
  exit 1
fi

echo "Fetching Cloud Run services for project: $project..."
service=$(gcloud run services list --project="$project" --format="value(name)" | fzf --prompt="Select Cloud Run service: ")

if [[ -z "$service" ]]; then
  echo "No service selected." >&2
  exit 1
fi

echo "Fetching logs for service: $service"
gcloud logging read \
  "resource.type=cloud_run_revision AND resource.labels.service_name=${service}" \
  --project="$project" \
  --limit=100 \
  --order=desc \
  --format="value(timestamp, textPayload)"
