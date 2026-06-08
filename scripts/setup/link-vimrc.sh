#!/bin/sh

# =============================================================================
# link-vimrc.sh
# Description : Creates or overwrites ~/.vimrc with the contents of
#               $DOTFILES_DIR/config/.vimrc.
# Dependencies: none
# Usage       : sh link-vimrc.sh
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

DOTFILES_VIMRC="$DOTFILES_DIR/config/.vimrc"
USER_VIMRC="$HOME/.vimrc"

[ -f "$DOTFILES_VIMRC" ] || die "Dotfiles vimrc not found at '$DOTFILES_VIMRC'."

# -- Check if already up to date ----------------------------------------------

if [ -f "$USER_VIMRC" ] && diff -q "$DOTFILES_VIMRC" "$USER_VIMRC" >/dev/null 2>&1; then
    info "Already up to date — '$USER_VIMRC' matches '$DOTFILES_VIMRC'."
    exit 0
fi

# -- Backup existing vimrc ----------------------------------------------------

if [ -f "$USER_VIMRC" ]; then
    BACKUP="${USER_VIMRC}.backup.$(date +%Y%m%d%H%M%S)"
    info "Backing up existing '$USER_VIMRC' to '$BACKUP'..."
    mv "$USER_VIMRC" "$BACKUP" || die "Failed to back up '$USER_VIMRC'."
fi

# -- Write vimrc --------------------------------------------------------------

cp "$DOTFILES_VIMRC" "$USER_VIMRC" || die "Failed to copy '$DOTFILES_VIMRC' to '$USER_VIMRC'."

info "Copied '$DOTFILES_VIMRC' → '$USER_VIMRC'."
info "Note: future changes to '$DOTFILES_VIMRC' require re-running this script to take effect."