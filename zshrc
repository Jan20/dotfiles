alias python=python3	

source $DOTFILE_DIR'/commands'
source $DOTFILE_DIR'/prompt'

# FZF
export FZF_DEFAULT_OPTS="--border=rounded --height=40% --reverse"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' squeeze-slashes true                             # SQUEEZING SLASHES
source <(fzf --zsh)                                                     # SOURCE FZF

# Completion
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort dummyvalue
autoload -Uz compinit && compinit

# Python
alias activate='source venv/bin/activate'

