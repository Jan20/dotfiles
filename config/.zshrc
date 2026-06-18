source ~/Developer/tools/dotfiles/.env
export FZF_DEFAULT_OPTS=" --border=rounded --height=45% --reverse"

# -- Tools (auto-add to PATH if installed) ------------------------------------

[ -d "$TOOLS_DIR/bat/bin" ] && export PATH="$TOOLS_DIR/bat/bin:$PATH"
[ -d "$TOOLS_DIR/fzf/bin" ] && export PATH="$TOOLS_DIR/fzf/bin:$PATH"

# -- Completion ---------------------------------------------------------------

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' squeeze-slashes true                             
source <(fzf --zsh)                                                 

# Completion
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort dummyvalue
autoload -Uz compinit && compinit

source "$DOTFILES_DIR/config/prompt"
source "$DOTFILES_DIR/config/commands.sh"
