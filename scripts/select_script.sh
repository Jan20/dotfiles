#!/bin/sh

select_shell_script() {
  find_cmd="find . \( -path '*/cloud_build' -o -path '*/node_modules' -o -path '*/google-cloud-sdk' \) -prune -o -type f -name '*.sh' -print"
  eval "$find_cmd" | fzf --prompt="Select a shell script to run: "
}

selected=$(select_shell_script)

if [ -n "$selected" ]; then
  echo "Running: $selected"
  sh "$selected"
else
  echo "No script selected."
fi
