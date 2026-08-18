bindkey -s "^A" 'eval $(fzf < $DOTFILES_DIR/lists/applications.txt)\n'                                      # APPLICATIONS
bindkey -s "^E" 'cd ~/Desktop \n'                                                                           # GO TO DESKTOP
bindkey -s "^H" 'cd ~/Developer \n'                                                                         # GO TO DEVELOPER DIR
bindkey -s "^N" 'sh $DOTFILES_DIR/scripts/execute_npm_script.sh \n'                                         # EXECUTE NPM SCRIPT
bindkey -s "^O" '[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || webstorm . \n' # OPEN PROJECT
bindkey -s "^v" 'eval "$(fzf < $DOTFILES_DIR/lists/config.txt)"\n'                                          # CONFIG
bindkey -s "^G" 'eval $(fzf < $DOTFILES_DIR/lists/git.txt) \n'                                              # GIT
bindkey -s "^W" 'cd $(find ~/Documents -maxdepth 4 -type d | fzf)\n'                                        # SEARCH DOCS
bindkey -s "^Y" 'sh $DOTFILES_DIR/scripts/general/execute-shell-script.sh \n'                               # EXECUTE SCRIPT
bindkey -s "^F" "cd \$(\$DOTFILES_DIR/scripts/general/select-project.sh)\n"                                 # CHANGE PROJECT
bindkey -s "^D" "cd \$(\$DOTFILES_DIR/scripts/general/select-dir.sh)\n"                                     # CHANGE DIR
alias a='eval $(fzf < $DOTFILES_DIR/lists/agents.txt)'                                                      # AGENTS 
alias d='eval $(fzf < $DOTFILES_DIR/lists/docker.txt)'                                                      # DOCKER
alias l='tree -C -L2'                                                                                       # TREE
alias c='clear'                                                                                             # CLEAR
alias f="cd \$(\$DOTFILES_DIR/scripts/general/select-project.sh)"                                           # SEARCH DIRECTORY
alias ff='sh $DOTFILES_DIR/scripts/general/open-file.sh'                                                    # OPEN_FILE
alias hh='eval $(fzf < ~/.zsh_history)'                                                                     # HISTORY
alias kk='eval $(fzf < $DOTFILES_DIR/lists/kubernetes.txt)'                                                 # KUBERNETES
alias kkk='eval $(fzf < $TASKS_DIR/contacts.txt)'                                                           # CONTACTS
alias i='eval $(fzf < $DOTFILES_DIR/lists/terraform.txt)'                                                   # TERRAFORM
alias j='eval $(fzf < $DOTFILES_DIR/lists/general-commands.txt)'                                            # GENERAL COMMANDS
alias b='sh $DOTFILES_DIR/scripts/stories.sh'                                                               # STORIES
alias ii='eval $(fzf < $DOTFILES_DIR/lists/information.txt)'                                                # INFORMATION
alias jj='sh $DOTFILES_DIR/scripts/search.sh'                                                               # SEARCH
alias g='eval $(fzf < $DOTFILES_DIR/lists/git.txt)'	                                                        # GIT
alias gg='eval $(fzf < $DOTFILES_DIR/lists/gcloud.txt)'                                                     # GCLOUD
alias n='eval $(fzf < $DOTFILES_DIR/lists/npm.txt)'	                                                        # NPM
alias mm='DOCKER_ENABLED=$((1 - DOCKER_ENABLED))'                                                           # ENABLE DOCKER
alias o='[ -f "pom.xml" ] && idea . || { [ -f "requirements.txt" ] } && pycharm . || code .'                # OPEN PROJECT
alias p='eval $(fzf < $DOTFILES_DIR/lists/python.txt)'                                                      # PYTHON
alias ls='ls --color'                                                                                       # LS WITH COLOR
alias t='vim $TASKS_DIR/tasks.txt'                                                                          # TASKS
alias tt='sh $DOTFILES_DIR/scripts/jira/show-jira-stories.sh \n'                                            # SHOW JIRA STORY
alias s="cd \$(\$DOTFILES_DIR/scripts/general/select-dir.sh)"                                               # SELECT DIR
alias u='source ~/.zshrc'                                                                                   # SOURCE ZSHRC
alias v='eval $(fzf < "$DOTFILES_DIR/lists/config.txt")'                                                    # CONFIG
alias x='cd $(find ~/Documents -maxdepth 4 -type d \( -name tools \) -prune -o -type d | fzf --preview="ls --color=always {}")' # JUMP TO DOCUMENTS DIR
alias xx='cd ~/Downloads'                                                                                   # GO TO DOWNLOADS
alias python=python3                                                                                        # PYTHON3
alias activate='source venv/bin/activate'                                                                   # ACTIVATE VENV
alias ..='cd ..'                                                                                            # RETURN TO PREVIOUS DIR
alias cc=copilot                                                                                            # COPILOT
alias pb=pbcopy
