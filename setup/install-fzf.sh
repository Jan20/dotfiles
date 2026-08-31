#!/usr/bin/env bash

# =============================================================================
# install-fzf.sh
# Description : Installs fzf from the official GitHub repository into
#               $TOOLS_DIR/fzf without relying on a package manager.
#               Also installs shell keybindings and fuzzy completion.
# Dependencies: git
# Usage       : bash install-fzf.sh
# Environment : TOOLS_DIR — required, e.g. export TOOLS_DIR="$HOME/Developer/tools"
# =============================================================================

# -- Configuration ------------------------------------------------------------

fzf_repo="https://github.com/junegunn/fzf.git"
fzf_version="${FZF_VERSION:-latest}"   # pin to e.g. "0.62.0" for reproducibility

# -- Preflight ----------------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required but not installed." >&2
    exit 1
fi

if [ -z "$TOOLS_DIR" ]; then
    echo "Error: TOOLS_DIR is not set. Export it before running this script." >&2
    exit 1
fi

fzf_dir="$TOOLS_DIR/fzf"

# -- Install or update --------------------------------------------------------

if [ -d "$fzf_dir" ]; then
    echo "==> fzf already cloned at '$fzf_dir'. Updating..."

    if ! git -C "$fzf_dir" fetch --tags --quiet; then
        echo "Error: Failed to fetch fzf updates." >&2
        exit 1
    fi

    if [ "$fzf_version" = "latest" ]; then
        if ! git -C "$fzf_dir" checkout master --quiet; then
            echo "Error: Failed to checkout fzf master branch." >&2
            exit 1
        fi

        if ! git -C "$fzf_dir" pull --rebase --quiet; then
            echo "Error: Failed to update fzf repo." >&2
            exit 1
        fi
    else
        if ! git -C "$fzf_dir" checkout "$fzf_version" --quiet; then
            echo "Error: Failed to checkout fzf version '$fzf_version'." >&2
            exit 1
        fi
    fi
else
    echo "==> Cloning fzf into '$fzf_dir'..."

    if [ "$fzf_version" = "latest" ]; then
        if ! git clone --depth 1 "$fzf_repo" "$fzf_dir"; then
            echo "Error: Failed to clone fzf." >&2
            exit 1
        fi
    else
        if ! git clone --depth 1 --branch "$fzf_version" "$fzf_repo" "$fzf_dir"; then
            echo "Error: Failed to clone fzf at version '$fzf_version'." >&2
            exit 1
        fi
    fi
fi

# -- Run fzf install script ---------------------------------------------------

echo "==> Running fzf install script..."
if ! "$fzf_dir/install" --bin --key-bindings --completion --no-update-rc; then
    echo "Error: fzf install script failed." >&2
    exit 1
fi

# -- Verify -------------------------------------------------------------------

if ! "$fzf_dir/bin/fzf" --version >/dev/null 2>&1; then
    echo "Error: fzf binary not found after install." >&2
    exit 1
fi

echo "==> fzf $("$fzf_dir/bin/fzf" --version) installed successfully."
echo "==> Binary: $fzf_dir/bin/fzf"
echo "==>"
echo "==> Add to your zshrc if not already present:"
echo "==>   export PATH=\"\$TOOLS_DIR/fzf/bin:\$PATH\""
echo "==>   [ -f \$TOOLS_DIR/fzf/.fzf.zsh ] && source \$TOOLS_DIR/fzf/.fzf.zsh"
