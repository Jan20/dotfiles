bindkey -s "^A" 'eval $(cat $DOTFILES_DIR/lists/applications.txt | fzf)\n'                                  # APPLICATIONS
bindkey -s "^E" 'cd ~/Desktop \n'                                                                           # GO TO DESKTOP
bindkey -s "^H" 'cd ~/Developer \n'                                                                         # GO TO DEVELOPER DIR
bindkey -s "^N" 'sh $DOTFILES_DIR/scripts/execute_npm_script.sh \n'                                         # EXECUTE NPM SCRIPT
bindkey -s "^O" '[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || webstorm . \n' # OPEN PROJECT
bindkey -s "^v" 'eval $(cat $DOTFILES_DIR/lists/config.txt | fzf)\n'                                        # CONFIG
bindkey -s "^G" 'eval $(cat $DOTFILES_DIR/lists/git.txt | fzf) \n'                                          # GIT
bindkey -s "^W" 'cd $(find ~/Documents -maxdepth 4 -type d | fzf)\n'                                        # SEARCH DOCS
bindkey -s "^Y" 'sh $DOTFILES_DIR/scripts/general/execute-shell-script.sh \n'                               # EXECUTE SCRIPT
bindkey -s "^F" "cd \$(\$DOTFILES_DIR/scripts/general/select-project.sh)\n"                                 # CHANGE PROJECT
bindkey -s "^D" "cd \$(\$DOTFILES_DIR/scripts/general/select-dir.sh)\n"                                     # CHANGE DIR
alias a='eval $(cat $DOTFILES_DIR/lists/agents.txt | fzf)'                                                  # AGENTS 
alias d='eval $(cat $DOTFILES_DIR/lists/docker.txt | fzf)'                                                  # DOCKER
alias l='tree -C -L2'                                                                                       # TREE
alias c='clear'                                                                                             # CLEAR
alias f="cd \$(\$DOTFILES_DIR/scripts/general/select-project.sh)"                                           # SEARCH DIRECTORY
alias ff='sh $DOTFILES_DIR/scripts/general/open-file.sh'                                                    # OPEN_FILE
alias hh='eval $(cat ~/.zsh_history | fzf)'                                                                 # HISTORY
alias kk='eval $(cat $DOTFILES_DIR/lists/kubernetes.txt | fzf)'                                             # KUBERNETES
alias i='cmd=$(cat $DOTFILES_DIR/lists/terraform.txt | fzf) && echo "$cmd" && eval "$cmd" && print -s "$cmd"' # TERRAFORM
alias j='eval $(cat $DOTFILES_DIR/lists/general-commands.txt | fzf)'                                        # GENERAL COMMANDS
alias b='sh $DOTFILES_DIR/scripts/stories.sh'                                                               # STORIES
alias ii='eval $(cat $DOTFILES_DIR/lists/information.txt | fzf)'                                            # INFORMATION
alias jj='sh $DOTFILES_DIR/scripts/search.sh'                                                               # SEARCH
alias g='eval $(cat $DOTFILES_DIR/lists/git.txt | fzf)'	                                                    # GIT
alias gg='eval $(cat $DOTFILES_DIR/lists/gcloud.txt | fzf)'                                                 # GCLOUD
alias n='eval $(cat $DOTFILES_DIR/lists/npm.txt | fzf)'	                                                    # NPM
alias mm='DOCKER_ENABLED=$((1 - DOCKER_ENABLED))'                                                           # ENABLE DOCKER
alias o='[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || code .'                # OPEN PROJECT
alias p='eval $(cat $DOTFILES_DIR/lists/python.txt | fzf)'                                                  # PYTHON
alias ls='ls --color'                                                                                       # LS WITH COLOR
alias t='vim $DOCUMENTS_DIR/tasks.txt'                                                                      # TASKS
alias tt='sh $DOTFILES_DIR/scripts/jira/show-jira-stories.sh \n'                                            # SHOW JIRA STORY
alias s="cd \$(\$DOTFILES_DIR/scripts/general/select-dir.sh)"                                               # SELECT DIR
alias ss='eval $(cat $DOTFILES_DIR/lists/spotify.txt | fzf)'                                                # SPOTIFY
alias u='source ~/.zshrc'                                                                                   # SOURCE ZSHRC FILE
alias v='eval $(cat $DOTFILES_DIR/lists/config.txt | fzf)'                                                  # CONFIG
alias x='cd $(find ~/Documents -maxdepth 4 -type d \( -name tools \) -prune -o -type d | fzf --preview="ls --color=always {}")' # JUMP TO DOCUMENTS DIR
alias python=python3                                                                                        # PYTHON3
alias activate='source venv/bin/activate'                                                                   # ACTIVATE VENV
alias ..='cd ..'                                                                                            # RETURN TO PREVIOUS DIR
alias cc=copilot                                                                                            # COPILOT
alias pb=pbcopy
