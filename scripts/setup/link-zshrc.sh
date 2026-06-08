#!/bin/sh

# =============================================================================
# link-zshrc.sh
# Description : Appends a source reference to $DOTFILES_DIR/config/.zshrc
#               into ~/.zshrc, so the dotfiles zshrc is loaded on shell start.
# Dependencies: none
# Usage       : sh link-zshrc.sh
# Environment : DOTFILES_DIR — required, e.g. export DOTFILES_DIR="$HOME/Developer/dotfiles"
# =============================================================================

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

info() {
    echo "==> $1"
}

# -- Preflight ----------------------------------------------------------------

[ -n "$DOTFILES_DIR" ] || die "DOTFILES_DIR is not set. Export it before running this script."

DOTFILES_ZSHRC="$DOTFILES_DIR/config/.zshrc"
USER_ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source \"$DOTFILES_ZSHRC\""

[ -f "$DOTFILES_ZSHRC" ] || die "Dotfiles zshrc not found at '$DOTFILES_ZSHRC'."

# -- Check if already linked --------------------------------------------------

if grep -qF "$SOURCE_LINE" "$USER_ZSHRC" 2>/dev/null; then
    info "Already linked — '$USER_ZSHRC' already sources '$DOTFILES_ZSHRC'."
    exit 0
fi

# -- Append source line -------------------------------------------------------

echo "" >> "$USER_ZSHRC"
echo "# Dotfiles" >> "$USER_ZSHRC"
echo "$SOURCE_LINE" >> "$USER_ZSHRC"

info "Linked '$DOTFILES_ZSHRC' into '$USER_ZSHRC'."
info "Reload your shell to apply: source ~/.zshrc"