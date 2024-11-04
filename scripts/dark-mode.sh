#!/bin/bash

# Toggle Dark/Light mode
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
    echo "Switched to Light Mode"
else
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    echo "Switched to Dark Mode"
fi
