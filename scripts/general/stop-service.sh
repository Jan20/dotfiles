#!/bin/sh

# =============================================================================
# stop-service.sh
# Description : Finds and kills the process occupying a given port.
#               Port is either passed as an argument or selected via fzf.
# Dependencies: lsof, kill, fzf (optional — only needed for interactive mode)
# Usage       : sh stop-service.sh [port]
#               sh stop-service.sh 4200
#               sh stop-service.sh        (launches fzf port picker)
# =============================================================================

# -- Configuration ------------------------------------------------------------

COMMON_PORTS="3000 3001 4200 5000 5001 5173 8080 8081 8443 9000"

# -- Helpers ------------------------------------------------------------------

die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# -- Preflight ----------------------------------------------------------------

command -v lsof >/dev/null 2>&1 || die "lsof is required but not installed."
command -v fzf >/dev/null 2>&1 || die "No port given and fzf is not installed."

# -- Resolve port -------------------------------------------------------------

if [ -n "$1" ]; then
    PORT="$1"
else
    PORT=$(echo "$COMMON_PORTS" | tr ' ' '\n' | fzf --prompt="Select port to kill: ")
    [ -z "$PORT" ] && die "No port selected."
fi

# Validate that port is a number
case "$PORT" in
    ''|*[!0-9]*) die "Invalid port: '$PORT'. Must be a number." ;;
esac

# -- Find process -------------------------------------------------------------

PID=$(lsof -ti :"$PORT")

[ -z "$PID" ] && { echo "No process found on port $PORT."; exit 0; }

# -- Kill process -------------------------------------------------------------

echo "Killing PID $PID on port $PORT..."
kill -9 "$PID" || die "Failed to kill PID $PID."
echo "Done."
