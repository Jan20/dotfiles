#!/bin/bash

# Prompt the user for a search term
read -p "Enter the search term: " search_term

# Use grep to search for the term, exclude node_modules, and pipe results to fzf
selected_file=$(grep -rl --exclude-dir=node_modules "$search_term" . | fzf)

# Check if a file was selected
if [ -n "$selected_file" ]; then
  # Open the selected file in vim
  vim "$selected_file"
else
  echo "No file selected or no match found."
fi
