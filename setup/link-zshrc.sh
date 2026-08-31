#!/usr/bin/env bash

# =============================================================================
# link-zshrc.sh
# Description : Appends a source reference to $DOTFILES_DIR/config/.zshrc
#               into ~/.zshrc, so the dotfiles zshrc is loaded on shell start.
#               Idempotent — safe to run multiple times.
# Dependencies: none
# Usage       : bash link-zshrc.sh
# Environment : DOTFILES_DIR — required, e.g. export DOTFILES_DIR="$HOME/Developer/dotfiles"
# =============================================================================

# -- Preflight ----------------------------------------------------------------

if [ -z "$DOTFILES_DIR" ]; then
    echo "Error: DOTFILES_DIR is not set. Export it before running this script." >&2
    exit 1
fi

dotfiles_zshrc="$DOTFILES_DIR/config/.zshrc"
user_zshrc="$HOME/.zshrc"
source_line="source \"$dotfiles_zshrc\""

if [ ! -f "$dotfiles_zshrc" ]; then
    echo "Error: Dotfiles zshrc not found at '$dotfiles_zshrc'." >&2
    exit 1
fi

# -- Check if already linked --------------------------------------------------

if grep -qF "$source_line" "$user_zshrc" 2>/dev/null; then
    echo "==> Already linked — '$user_zshrc' already sources '$dotfiles_zshrc'."
    exit 0
fi

# -- Append source line -------------------------------------------------------

{
    echo ""
    echo "# Dotfiles"
    echo "$source_line"
} >> "$user_zshrc"

echo "==> Linked '$dotfiles_zshrc' into '$user_zshrc'."
echo "==> Reload your shell to apply: source ~/.zshrc"
