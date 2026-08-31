#!/usr/bin/env bash

# =============================================================================
# toggle-dark-mode.sh
# Description : Toggles macOS between Dark and Light appearance mode.
# Usage       : bash toggle-dark-mode.sh
# Dependencies: osascript, defaults
# =============================================================================

current=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

if [ "$current" = "Dark" ]; then
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
    echo "Switched to Light Mode"
else
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
    echo "Switched to Dark Mode"
fi