# FZF
export FZF_DEFAULT_OPTS=" --border=rounded --height=70% --reverse" 

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' squeeze-slashes true                             
source <(fzf --zsh)                                                 

# Completion
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort dummyvalue
autoload -Uz compinit && compinit
