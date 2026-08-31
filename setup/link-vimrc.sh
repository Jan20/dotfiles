#!/usr/bin/env bash

# =============================================================================
# link-vimrc.sh
# Description : Creates or overwrites ~/.vimrc with the contents of
#               $DOTFILES_DIR/config/.vimrc.
# Usage       : bash link-vimrc.sh
# Dependencies: none
# Environment : DOTFILES_DIR — required, e.g. export DOTFILES_DIR="$HOME/Developer/dotfiles"
# =============================================================================

set -euo pipefail

# -- Preflight ----------------------------------------------------------------

if [ -z "${DOTFILES_DIR:-}" ]; then
    echo "Error: DOTFILES_DIR is not set. Export it before running this script." >&2
    exit 1
fi

dotfiles_vimrc="$DOTFILES_DIR/config/.vimrc"
user_vimrc="$HOME/.vimrc"

if [ ! -f "$dotfiles_vimrc" ]; then
    echo "Error: Dotfiles vimrc not found at '$dotfiles_vimrc'." >&2
    exit 1
fi

# -- Check if already up to date ----------------------------------------------

if [ -f "$user_vimrc" ] && diff -q "$dotfiles_vimrc" "$user_vimrc" >/dev/null 2>&1; then
    echo "==> Already up to date — '$user_vimrc' matches '$dotfiles_vimrc'."
    exit 0
fi

# -- Backup existing vimrc ----------------------------------------------------

if [ -f "$user_vimrc" ]; then
    backup="${user_vimrc}.backup.$(date +%Y%m%d%H%M%S)"
    echo "==> Backing up existing '$user_vimrc' to '$backup'..."
    mv "$user_vimrc" "$backup"
fi

# -- Write vimrc ---------------------------------------------------------------

cp "$dotfiles_vimrc" "$user_vimrc"

echo "==> Copied '$dotfiles_vimrc' → '$user_vimrc'."
echo "==> Note: future changes to '$dotfiles_vimrc' require re-running this script to take effect."
