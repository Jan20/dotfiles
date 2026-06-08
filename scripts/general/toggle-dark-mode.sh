#!/bin/sh

# =============================================================================
# toggle-dark-mode.sh
# Description : Toggles macOS between Dark and Light appearance mode.
# Dependencies: osascript, defaults
# Usage       : sh toggle-dark-mode.sh
# =============================================================================

CURRENT=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

if [ "$CURRENT" = "Dark" ]; then
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
    echo "Switched to Light Mode"
else
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
    echo "Switched to Dark Mode"
fi