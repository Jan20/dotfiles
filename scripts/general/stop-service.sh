#!/usr/bin/env bash

# =============================================================================
# stop-service.sh
# Description : Finds and kills the process occupying a given port.
#               Port is either passed as an argument or selected via fzf.
# Usage       : bash stop-service.sh [port]
#               bash stop-service.sh 4200
#               bash stop-service.sh        (launches fzf port picker)
# Dependencies: lsof, kill, fzf (optional — only needed for interactive mode)
# =============================================================================

common_ports="3000 3001 4200 5000 5001 5173 8080 8081 8443 9000"

# -- Preflight ----------------------------------------------------------------

if ! command -v lsof >/dev/null 2>&1; then
    echo "Error: lsof is required but not installed." >&2
    exit 1
fi

# -- Resolve port ---------------------------------------------------------------

if [ -n "$1" ]; then
    port="$1"
else
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: No port given and fzf is not installed." >&2
        exit 1
    fi

    port=$(echo "$common_ports" | tr ' ' '\n' | fzf --prompt="Select port to kill: ")

    if [ -z "$port" ]; then
        echo "Error: No port selected." >&2
        exit 1
    fi
fi

# Validate that port is a number
case "$port" in
    ''|*[!0-9]*)
        echo "Error: Invalid port: '$port'. Must be a number." >&2
        exit 1
        ;;
esac

# -- Find process -----------------------------------------------------------------

pid=$(lsof -ti :"$port")

if [ -z "$pid" ]; then
    echo "No process found on port $port."
    exit 0
fi

# -- Kill process -----------------------------------------------------------------

echo "Killing PID $pid on port $port..."

if ! kill -9 "$pid"; then
    echo "Error: Failed to kill PID $pid." >&2
    exit 1
fi

echo "Done."
