bindkey -s "^A" 'eval $(cat $DOTFILES_DIR/lists/applications.txt | fzf)\n'                                  # APPLICATIONS
bindkey -s "^E" 'cd ~/Desktop \n'												                            # DESKTOP
bindkey -s "^H" 'cd ~/Developer \n'											                                # GO TO DEVELOPER DIR
bindkey -s "^N" 'eval $(cat $DOTFILES_DIR/lists/npm.txt | fzf) \n'                                          # NPM
bindkey -s "^O" '[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || code .\n'      # OPEN PROJECT
bindkey -s "^v" 'eval $(cat $DOTFILES_DIR/lists/config.txt | fzf)\n'                                        # CONFIG
bindkey -s "^G" 'eval $(cat $DOTFILES_DIR/lists/git.txt | fzf) \n'                                          # GIT
bindkey -s "^W" 'cd $(find ~/Documents -maxdepth 4 -type d | fzf)\n'                                        # SEARCH DOCS
bindkey -s "^Y" 'sh $DOTFILES_DIR/scripts/select_script.sh \n'                                              # EXECUTE SCRIPT
bindkey -s "^F" 'cd $(find ~/Developer -maxdepth 5 -type d \\( -name tools \\) -prune -o -type d | fzf) \n' # SEARCH DIRECTORY
alias x='cd $(find ~/Documents -maxdepth 4 -type d | fzf)'                                                  # SEARCH DOCUMENTS
alias d='eval $(cat $DOTFILES_DIR/lists/docker.txt | fzf)'                                                  # DOCKER
alias l='tree -C -L2'                                                                                       # TREE
alias c='clear'													                                            # CLEAR
alias ff='sh $DOTFILES_DIR/scripts/open_file.sh'                                                            # OPEN_FILE
alias h='cd ~/Developer'					
alias hh='eval $(cat ~/.zsh_history | fzf)'                                                                 # HISTORY
alias kk='eval $(cat $DOTFILES_DIR/lists/kubernetes.txt | fzf)'					                            # KUBERNETES 
alias i='cmd=$(cat $DOTFILES_DIR/lists/terraform.txt | fzf) && echo "$cmd" && eval "$cmd" && print -s "$cmd"'      # TERRAFORM
alias j='eval $(cat $DOTFILES_DIR/lists/commands.txt | fzf)'                                                # GENERAL COMMANDS
alias b='sh $DOTFILES_DIR/scripts/stories.sh'                                                               # STORIES
alias jj='sh $DOTFILES_DIR/scripts/search.sh'			                                                    # SEARCH
alias g='eval $(cat $DOTFILES_DIR/lists/git.txt | fzf)'	                                                    # GIT
alias gg='eval $(cat $DOTFILES_DIR/lists/gcloud.txt | fzf)'                                                 # GCLOUD
alias n='eval $(cat $DOTFILES_DIR/lists/npm.txt | fzf)'	                                                    # NPM
alias mm='DOCKER_ENABLED=$((1 - DOCKER_ENABLED))'                                                           # ENABLE DOCKER
alias mark='MARK=$(echo $PWD) && echo "$MARK" | pbcopy'                                                     # MARK DIR
alias recall='echo $MARK | xargs -I {} echo {} && echo $MARK | pbcopy'			                            # RECALL DIR
alias o='[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || code .'                # OPEN PROJECT
alias p='eval $(cat $DOTFILES_DIR/lists/python.txt | fzf)'                                                  # PYTHON
alias ls='ls --color'                    
alias f='cd $(find ~/Developer -maxdepth 4 -type d \( -name tools \) -prune -o -type d | fzf)'              # SEARCH DIRECTORY
alias s='cd $(find . -type d \( -name .angular -o -name .git -o -name node_modules \) -prune -o -type d | fzf)' # SELECT DIRECTORY
alias ss='eval $(cat $DOTFILES_DIR/lists/spotify.txt | fzf)'			                                    # SPOTIFY
alias t='vim -c "set filetype=markdown" $DOTFILES_DIR/lists/tasks.txt'                                      # TASKS
alias u='source ~/.zshrc'                                                                                   # SOURCE ZSHRC FILE
alias v='eval $(cat $DOTFILES_DIR/lists/config.txt | fzf)'                                                  # CONFIG
alias xx='open $(find ~/documents -type d \( -name node_modules -o -name .angular -o -name target -o -name .git \) -prune -o -type f ! -name "*.png" | fzf --preview="bat --color=always {}")' # OPEN FILE
alias python=python3                                                                                        # PYTHON3
alias activate='source venv/bin/activate'                                                                   # ACTIVATE VENV
alias ..='cd ..'                                                                                            # RETURN TO PREVIOUS DIR
