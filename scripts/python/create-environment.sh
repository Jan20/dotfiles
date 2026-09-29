#!/usr/bin/env bash

# =============================================================================
# create-environment.sh
# Description : Creates (if needed) and activates a Python virtual environment,
#               then upgrades core packaging tools.
# Usage       : . ./create-environment.sh           (must be sourced to activate)
#               . ./create-environment.sh --create   (force recreate the venv)
# Dependencies: python3
# =============================================================================

venv_dir="${VENV_DIR:-venv}"
python_bin="${PYTHON:-python3}"

# -- Preflight ----------------------------------------------------------------

if ! command -v "$python_bin" >/dev/null 2>&1; then
    echo "Error: Python not found. Set PYTHON= to override." >&2
    return 1
fi

# -- Create venv (if missing or --create passed) ------------------------------

if [ ! -d "$venv_dir" ] || [ "${1:-}" = "--create" ]; then
    echo "Creating virtual environment in '$venv_dir'..."

    if ! "$python_bin" -m venv "$venv_dir"; then
        echo "Error: Failed to create virtual environment." >&2
        return 1
    fi
fi

# -- Activate -------------------------------------------------------------------

echo "Activating '$venv_dir'..."

if ! . "$venv_dir/bin/activate"; then
    echo "Error: Failed to activate virtual environment." >&2
    return 1
fi

# -- Upgrade packaging tools ------------------------------------------------------

echo "Upgrading pip, setuptools, wheel..."

if ! python -m pip install --upgrade --quiet pip setuptools wheel; then
    echo "Error: Failed to upgrade packaging tools." >&2
    return 1
fi

echo "Done. Python: $(python --version) | pip: $(pip --version | cut -d' ' -f1-2)"
