#!/usr/bin/env bash

# =============================================================================
# unzip-archive.sh
# Description : Fuzzy-finds a zip file in the current directory and extracts
#               it into a subdirectory named after the archive.
# Usage       : bash unzip-archive.sh
# Dependencies: find, fzf, unzip
# =============================================================================

search_dir="${SEARCH_DIR:-$PWD}"
archive_ext="zip"

# -- Preflight ----------------------------------------------------------------

if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is required but not installed." >&2
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    echo "Error: unzip is required but not installed." >&2
    exit 1
fi

# -- Select archive ---------------------------------------------------------------

archive=$(
    find "$search_dir"           \
        -maxdepth 1               \
        -name "*.${archive_ext}"  \
        -type f                   \
    | sed "s|$search_dir/||"     \
    | fzf                        \
        --prompt="Select archive: " \
        --preview="unzip -l $search_dir/{} | tail -n +4"
)

if [ -z "$archive" ]; then
    echo "Error: No archive selected." >&2
    exit 1
fi

# -- Extract ------------------------------------------------------------------------

archive_path="$search_dir/$archive"
output_dir="$search_dir/${archive%."${archive_ext}"}"

echo "Extracting '$archive' → '$output_dir'"

if ! mkdir -p "$output_dir"; then
    echo "Error: Failed to create '$output_dir'." >&2
    exit 1
fi

if ! unzip -q "$archive_path" -d "$output_dir"; then
    echo "Error: Failed to extract '$archive_path'." >&2
    exit 1
fi

if ! rm "$archive_path"; then
    echo "Error: Extraction succeeded but failed to delete '$archive_path'." >&2
    exit 1
fi

echo "Deleted '$archive'."
echo "Done."