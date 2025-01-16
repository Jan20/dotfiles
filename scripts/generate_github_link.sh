# Function to to open a file on Github
# Ensure the current directory is a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a Git repository."
  return 1
fi

# Get the remote GitHub URL (assumes 'origin' points to GitHub)
remote_url=$(git config --get remote.origin.url)

# Transform SSH URL to HTTPS if needed
if [[ $remote_url == git@github.com:* ]]; then
  remote_url="https://github.com/${remote_url#git@github.com:}"
  remote_url="${remote_url%.git}"
elif [[ $remote_url == https://github.com/* ]]; then
  remote_url="${remote_url%.git}"
else
  echo "Remote URL is not a GitHub repository."
  return 1
fi

# Select a file tracked by Git using fzf
selected_file=$(git ls-files | fzf --prompt="Select a file: ")
if [[ -z $selected_file ]]; then
  echo "No file selected."
  return 1
fi

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Build the GitHub URL
open "$remote_url/blob/$branch_name/$selected_file"
