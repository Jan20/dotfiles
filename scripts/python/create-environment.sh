#!/bin/sh

# =============================================================================
# setup.sh
# Description : Creates (if needed) and activates a Python virtual environment,
#               then upgrades core packaging tools.
# Dependencies: python3
# Usage       : . ./venv.sh           (must be sourced to activate in current shell)
#               . ./venv.sh --create  (force recreate the venv)
# =============================================================================

# -- Configuration ------------------------------------------------------------

VENV_DIR="${VENV_DIR:-venv}"
PYTHON="${PYTHON:-python3}"

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    return "${2:-1}"
}

# -- Preflight ----------------------------------------------------------------

command -v "$PYTHON" >/dev/null 2>&1 || die "Python not found. Set PYTHON= to override."

# -- Create venv (if missing or --create passed) ------------------------------

if [ ! -d "$VENV_DIR" ] || [ "${1:-}" = "--create" ]; then
    echo "Creating virtual environment in '$VENV_DIR'..."
    "$PYTHON" -m venv "$VENV_DIR" || die "Failed to create virtual environment."
fi

# -- Activate -----------------------------------------------------------------

echo "Activating '$VENV_DIR'..."
. "$VENV_DIR/bin/activate" || die "Failed to activate virtual environment."

# -- Upgrade packaging tools --------------------------------------------------

echo "Upgrading pip, setuptools, wheel..."
python -m pip install --upgrade --quiet pip setuptools wheel || die "Failed to upgrade packaging tools."

echo "Done. Python: $(python --version) | pip: $(pip --version | cut -d' ' -f1-2)"
