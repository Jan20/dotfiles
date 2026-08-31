#!/usr/bin/env bash

# =============================================================================
# install-bat.sh
# Description : Installs a fixed bat release binary from GitHub into
#               $TOOLS_DIR/bat without relying on a package manager.
# Usage       : bash install-bat.sh
# Environment : TOOLS_DIR — required, e.g. export TOOLS_DIR="$HOME/Developer/tools"
# Dependencies: curl, tar, find
# =============================================================================

bat_version="0.26.0"

# -- Preflight -----------------------------------------------------------------

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required but not installed." >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "Error: tar is required but not installed." >&2
    exit 1
fi

if [ -z "$TOOLS_DIR" ]; then
    echo "Error: TOOLS_DIR is not set. Export it before running this script." >&2
    exit 1
fi

# -- Detect architecture ---------------------------------------------------------

arch=$(uname -m)

case "$arch" in
    arm64) bat_platform="aarch64-apple-darwin" ;;
    x86_64) bat_platform="x86_64-apple-darwin" ;;
    *)
        echo "Error: Unsupported architecture: $arch" >&2
        exit 1
        ;;
esac

echo "==> Installing bat $bat_version for $bat_platform..."

# -- Prepare directories ---------------------------------------------------------

bat_dir="$TOOLS_DIR/bat"
tmp_dir=$(mktemp -d)

if ! mkdir -p "$bat_dir/bin"; then
    echo "Error: Failed to create '$bat_dir/bin'." >&2
    exit 1
fi

# -- Download ----------------------------------------------------------------------

archive="bat-v${bat_version}-${bat_platform}.tar.gz"
download_url="https://github.com/sharkdp/bat/releases/download/v${bat_version}/${archive}"

echo "==> Downloading $archive..."
if ! curl --silent --fail --location "$download_url" --output "$tmp_dir/$archive"; then
    echo "Error: Failed to download bat from '$download_url'." >&2
    exit 1
fi

# -- Extract binary ------------------------------------------------------------------

echo "==> Extracting..."
if ! tar -xzf "$tmp_dir/$archive" -C "$tmp_dir"; then
    echo "Error: Failed to extract archive." >&2
    exit 1
fi

extracted_bin=$(find "$tmp_dir" -name "bat" -type f | head -n 1)
if [ -z "$extracted_bin" ]; then
    echo "Error: bat binary not found in extracted archive." >&2
    exit 1
fi

if ! mv "$extracted_bin" "$bat_dir/bin/bat"; then
    echo "Error: Failed to move bat binary to '$bat_dir/bin'." >&2
    exit 1
fi

if ! chmod +x "$bat_dir/bin/bat"; then
    echo "Error: Failed to make bat binary executable." >&2
    exit 1
fi

# -- Cleanup -------------------------------------------------------------------------

rm -rf "$tmp_dir"

# -- Verify --------------------------------------------------------------------------

if ! "$bat_dir/bin/bat" --version >/dev/null 2>&1; then
    echo "Error: bat binary not working after install." >&2
    exit 1
fi

echo "==> bat $("$bat_dir/bin/bat" --version) installed successfully."
echo "==> Binary: $bat_dir/bin/bat"
