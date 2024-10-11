# Searches and opens a directory
open_dir() {   
   local DIRECTORY=$(find . -type d ! -path '*/google-cloud-sdk/*' ! -path '*/node_modules/*' ! -path '*/.angular/*' | fzf)
   if [[ -n "$DIRECTORY" ]]; then
       cd "$DIRECTORY"
   fi
}
alias f=open_dir

# Open a local file
function open_local_file {
  local file=$(fzf --preview='bat --color=always {}') 
  [ -n "$file" ] && vim "$file"
}
alias ff=open_local_file

alias dd='eval $(cat ~/.zsh_history | fzf)'
alias jj='eval $(cat ~/Developer/tools/terminal-setup/lists/commands.txt | fzf)'
alias gg='eval $(cat ~/Developer/tools/terminal-setup/lists/git_commands.txt | fzf)'
