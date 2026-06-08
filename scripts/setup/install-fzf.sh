#!/bin/sh

# =============================================================================
# install-fzf.sh
# Description : Installs fzf from the official GitHub repository into
#               $SOURCE_CODE_HOME/tools/fzf without relying on a package manager.
#               Also installs shell keybindings and fuzzy completion.
# Dependencies: git
# Usage       : sh install-fzf.sh
# Environment : SOURCE_CODE_HOME — required, e.g. export SOURCE_CODE_HOME="$HOME/Developer"
# =============================================================================

# -- Configuration ------------------------------------------------------------

FZF_REPO="https://github.com/junegunn/fzf.git"
FZF_VERSION="${FZF_VERSION:-latest}"   # pin to e.g. "0.62.0" for reproducibility

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

info() {
    echo "==> $1"
}

# -- Preflight ----------------------------------------------------------------

command -v git >/dev/null 2>&1 || die "git is required but not installed."

[ -n "$SOURCE_CODE_HOME" ] || die "SOURCE_CODE_HOME is not set. Export it before running this script."

FZF_DIR="$SOURCE_CODE_HOME/tools/fzf"

# -- Install or update --------------------------------------------------------

if [ -d "$FZF_DIR" ]; then
    info "fzf already cloned at '$FZF_DIR'. Pulling latest changes..."
    git -C "$FZF_DIR" pull --rebase --quiet || die "Failed to update fzf repo."
else
    info "Cloning fzf into '$FZF_DIR'..."
    if [ "$FZF_VERSION" = "latest" ]; then
        git clone --depth 1 "$FZF_REPO" "$FZF_DIR" || die "Failed to clone fzf."
    else
        git clone --depth 1 --branch "$FZF_VERSION" "$FZF_REPO" "$FZF_DIR" \
            || die "Failed to clone fzf at version '$FZF_VERSION'."
    fi
fi

# -- Run fzf install script ---------------------------------------------------

info "Running fzf install script..."
"$FZF_DIR/install" \
    --bin            \
    --key-bindings   \
    --completion     \
    --no-update-rc   \
    || die "fzf install script failed."

# -- Verify -------------------------------------------------------------------

"$FZF_DIR/bin/fzf" --version >/dev/null 2>&1 \
    || die "fzf binary not found after install."

info "fzf $("$FZF_DIR/bin/fzf" --version) installed successfully."
info "Binary: $FZF_DIR/bin/fzf"
info ""
info "Add to your zshrc if not already present:"
info "  export PATH=\"\$SOURCE_CODE_HOME/tools/fzf/bin:\$PATH\""
info "  [ -f \$SOURCE_CODE_HOME/tools/fzf/.fzf.zsh ] && source \$SOURCE_CODE_HOME/tools/fzf/.fzf.zsh"