#!/bin/sh

get_gcloud_value() {
  gcloud config get-value "$1" 2>/dev/null || echo "N/A"
}

GREEN='\033[0;32m'
RESET='\033[0m'

colorize() {
  value="$1"
  prefix="$2"
  width="${3:-37}"
  case "$value" in
    "$prefix"*) printf "${GREEN}%-${width}s${RESET}" "$value" ;;
    *)          printf "%-${width}s" "$value" ;;
  esac
}

ACCOUNT=$(get_gcloud_value account)
PROJECT=$(get_gcloud_value project)
BORDER="+------------------------------------------------------+"

echo "$BORDER"
printf "| %-15s %s|\n" "GCloud User:" "$(colorize "$ACCOUNT" "student")"
printf "| %-15s %s|\n" "GCP Project:" "$(colorize "$PROJECT" "qwiklabs")"
echo "$BORDER"