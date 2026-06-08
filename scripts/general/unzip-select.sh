#!/bin/sh

# =============================================================================
# unzip-select.sh
# Description : Fuzzy-finds a zip file in the current directory and extracts
#               it into a subdirectory named after the archive.
# Dependencies: find, fzf, unzip
# Usage       : sh unzip-select.sh
# =============================================================================

# -- Configuration ------------------------------------------------------------

SEARCH_DIR="${SEARCH_DIR:-$PWD}"
ARCHIVE_EXT="zip"

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# -- Preflight ----------------------------------------------------------------

command -v fzf   >/dev/null 2>&1 || die "fzf is required but not installed."
command -v unzip >/dev/null 2>&1 || die "unzip is required but not installed."

# -- Select archive -----------------------------------------------------------

ARCHIVE=$(
    find "$SEARCH_DIR"          \
        -maxdepth 1             \
        -name "*.${ARCHIVE_EXT}"\
        -type f                 \
    | sed "s|$SEARCH_DIR/||"    \
    | fzf                       \
        --prompt="Select archive: "                             \
        --preview="unzip -l $SEARCH_DIR/{} | tail -n +4"
)

[ -z "$ARCHIVE" ] && die "No archive selected."

# -- Extract ------------------------------------------------------------------

ARCHIVE_PATH="$SEARCH_DIR/$ARCHIVE"
OUTPUT_DIR="$SEARCH_DIR/${ARCHIVE%.${ARCHIVE_EXT}}"

echo "Extracting '$ARCHIVE' → '$OUTPUT_DIR'"

mkdir -p "$OUTPUT_DIR"                          || die "Failed to create '$OUTPUT_DIR'."
unzip -q "$ARCHIVE_PATH" -d "$OUTPUT_DIR"       || die "Failed to extract '$ARCHIVE_PATH'."

rm "$ARCHIVE_PATH" || die "Extraction succeeded but failed to delete '$ARCHIVE_PATH'."
echo "Deleted '$ARCHIVE'."

echo "Done."