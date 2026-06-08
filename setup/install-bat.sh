#!/bin/sh

# =============================================================================
# install-bat.sh
# Description : Installs the latest bat release binary from GitHub into
#               $SOURCE_CODE_HOME/tools/bat without relying on a package manager.
# Dependencies: curl, tar, find
# Usage       : sh install-bat.sh
# Environment : SOURCE_CODE_HOME — required, e.g. export SOURCE_CODE_HOME="$HOME/Developer"
# =============================================================================

# -- Configuration ------------------------------------------------------------

BAT_REPO="sharkdp/bat"
BAT_API="https://api.github.com/repos/$BAT_REPO/releases/latest"
BAT_PLATFORM="aarch64-apple-darwin"

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

info() {
    echo "==> $1"
}

# -- Preflight ----------------------------------------------------------------

command -v curl >/dev/null 2>&1 || die "curl is required but not installed."
command -v tar  >/dev/null 2>&1 || die "tar is required but not installed."

[ -n "$SOURCE_CODE_HOME" ] || die "SOURCE_CODE_HOME is not set. Export it before running this script."

# -- Detect architecture automatically ----------------------------------------

ARCH=$(uname -m)
case "$ARCH" in
    arm64)  BAT_PLATFORM="aarch64-apple-darwin" ;;
    x86_64) BAT_PLATFORM="x86_64-apple-darwin"  ;;
    *)      die "Unsupported architecture: $ARCH" ;;
esac

# -- Resolve latest version ---------------------------------------------------

info "Fetching latest bat release version..."
BAT_VERSION=$(
    curl --silent --fail "$BAT_API" \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": *"v\([^"]*\)".*/\1/'
) || die "Failed to fetch latest bat version from GitHub API."

[ -n "$BAT_VERSION" ] || die "Could not parse bat version from GitHub API response."

info "Latest version: $BAT_VERSION"

# -- Prepare directories ------------------------------------------------------

BAT_DIR="$SOURCE_CODE_HOME/tools/bat"
TMP_DIR=$(mktemp -d)

mkdir -p "$BAT_DIR/bin" || die "Failed to create '$BAT_DIR/bin'."

# -- Download -----------------------------------------------------------------

ARCHIVE="bat-v${BAT_VERSION}-${BAT_PLATFORM}.tar.gz"
DOWNLOAD_URL="https://github.com/$BAT_REPO/releases/download/v${BAT_VERSION}/${ARCHIVE}"

info "Downloading $ARCHIVE..."
curl --silent --fail --location "$DOWNLOAD_URL" \
    --output "$TMP_DIR/$ARCHIVE" \
    || die "Failed to download bat from '$DOWNLOAD_URL'."

# -- Extract binary -----------------------------------------------------------

info "Extracting..."
tar -xzf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR" || die "Failed to extract archive."

EXTRACTED_BIN=$(find "$TMP_DIR" -name "bat" -type f | head -n 1)
[ -n "$EXTRACTED_BIN" ] || die "bat binary not found in extracted archive."

mv "$EXTRACTED_BIN" "$BAT_DIR/bin/bat" || die "Failed to move bat binary to '$BAT_DIR/bin'."
chmod +x "$BAT_DIR/bin/bat"            || die "Failed to make bat binary executable."

# -- Cleanup ------------------------------------------------------------------

rm -rf "$TMP_DIR"

# -- Verify -------------------------------------------------------------------

"$BAT_DIR/bin/bat" --version >/dev/null 2>&1 \
    || die "bat binary not working after install."

info "bat $("$BAT_DIR/bin/bat" --version) installed successfully."
info "Binary: $BAT_DIR/bin/bat"
info ""
info "Add to your zshrc if not already present:"
info "  export PATH=\"\$SOURCE_CODE_HOME/tools/bat/bin:\$PATH\""