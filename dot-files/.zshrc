# Searches and opens a directory
open_dir() {
   local DIRECTORY=$(find . -type d ! -path '*/.git/*' ! -path '*/google-cloud-sdk/*' ! -path '*/venv/*' ! -path '*/node_modules/*' ! -path '*/.angular/*' | fzf)
   [[ -n "$DIRECTORY" ]] && cd "$DIRECTORY"
}
alias f=open_dir

# Open a local file
function open_local_file {
  local FILE=$(find . ! -path '*/.angular/*' ! -path '*/node_modules/*' ! -path '*/venv/*' ! -path '*/.git/*' | fzf --preview='bat --color=always {}') 
  [ -n "$FILE" ] && vim "$FILE"
}
alias ff=open_local_file

alias dd='eval $(cat ~/.zsh_history | fzf)'
alias jj='eval $(cat ~/Developer/tools/terminal-setup/lists/commands.txt | fzf)'
alias gg='eval $(cat ~/Developer/tools/terminal-setup/lists/git_commands.txt | fzf)'
alias ll='eval $(cat ~/Developer/tools/terminal-setup/lists/web-pages.txt | fzf)'
alias help='eval $(cat ~/Developer/tools/terminal-setup/lists/help.txt | fzf)'
