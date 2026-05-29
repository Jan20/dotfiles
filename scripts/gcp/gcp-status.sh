#!/bin/sh

# =============================================================================
# gcp-status.sh
# Description : Displays the current gcloud account, project, and quota project
#               with colour highlighting for known prefixes (e.g. qwiklabs).
# Dependencies: gcloud
# Usage       : ./gcp-status.sh
# =============================================================================

# -- Configuration ------------------------------------------------------------

# Prefixes that trigger green highlighting
ACCOUNT_PREFIX="student"
PROJECT_PREFIX="qwiklabs"

# Table layout
COL_LABEL_WIDTH=15   # width of  the left label column
COL_VALUE_WIDTH=37   # width of the right value column
BORDER="+------------------------------------------------------+"

# -- Colours ------------------------------------------------------------------

GREEN='\033[0;32m'
RESET='\033[0m'

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

get_gcloud_value() {
    gcloud config get-value "$1" 2>/dev/null || echo "N/A"
}

# Prints a value padded to COL_VALUE_WIDTH, in green if it matches the prefix.
colorize() {
    value="$1"
    prefix="$2"
    case "$value" in
        "$prefix"*) printf "${GREEN}%-${COL_VALUE_WIDTH}s${RESET}" "$value" ;;
        *)          printf "%-${COL_VALUE_WIDTH}s"                  "$value" ;;
    esac
}

print_row() {
    label="$1"
    value="$2"
    prefix="$3"
    printf "| %-${COL_LABEL_WIDTH}s %s|\n" "$label" "$(colorize "$value" "$prefix")"
}

# -- Preflight ----------------------------------------------------------------

command -v gcloud >/dev/null 2>&1 || die "gcloud is required but not installed."

# -- Main ---------------------------------------------------------------------

# Fetch all values in one subshell to avoid 3 separate gcloud calls blocking sequentially
ACCOUNT=$(get_gcloud_value account)
PROJECT=$(get_gcloud_value project)
QUOTA_PROJECT=$(get_gcloud_value billing/quota_project)

echo "$BORDER"
print_row "GCloud User:"   "$ACCOUNT"       "$ACCOUNT_PREFIX"
print_row "GCP Project:"   "$PROJECT"       "$PROJECT_PREFIX"
print_row "Quota Project:" "$QUOTA_PROJECT" "$PROJECT_PREFIX"
echo "$BORDER"