# Dotfile Repository

This repository contains a collection of a few dotfiles building the core of my Terminal setup. My setup revolves heavily around fzf and a range of txt files to store collections of various terminal commands, URLs, and notes. If you want to learn more about the thought-process behind this setup, you may want to visit: https://janladicha.de/engineering/efficient-terminal-setup

## Getting Started

**Step 1:** Create a new directory serving as home for the this repository.

```
mkdir -p ~/Developer/tools && cd ~/Developer/tools
```

**Step 2:** Clone this repository

```
git clone https://github.com/Jan20/terminal-setup
```

**Step 3:** Source the **commands** and **prompt** files in your ~/.zshrc file:

_~/.zshrc_ file:
```
echo "source $HOME/Developer/tools/dotfiles/commands >> ~/.zshrc
echo "source $HOME/Developer/tools/dotfiles/prompt >> ~/.zshrc
```

## Key Concepts

The magic happens in the **commands** file which contains a bunch of alias binding keys to specific commands like:

```
alias f='cd $(find ~/Developer -maxdepth 2 -type d \( -name tools \) -prune -o -type d | fzf)'
```

Now, by pressing the **f** key, you can search for a directory and cd into it.

<img width="1562" alt="Screenshot 2024-11-13 at 20 47 09" src="https://github.com/user-attachments/assets/654c455e-eb90-43e5-9c78-52be1c4245c0">

More interesting, we can also bind a key to display and execute commands:

```
alias g='eval $(cat ~/Developer/tools/dotfiles/lists/git.txt | fzf)'
```

<img width="1562" alt="Screenshot 2024-11-13 at 20 50 11" src="https://github.com/user-attachments/assets/b9ebe4e2-aea0-418d-a63f-9c97436e4f5a">

However, the concept is not limited to commands, we can store URLs and open them upon selection: 
```
alias l='eval $(cat ~/Developer/tools/dotfiles/lists/web-pages.txt | fzf)'
```

The project is structured as follows:

<img width="1562" alt="Screenshot 2024-11-12 at 07 23 40" src="https://github.com/user-attachments/assets/5f375efa-d8a8-48a1-9f68-d2f726652799">

By pressing the **v**, we can either quickly adjust the .zshrc file, commands file, etc:

<img width="1562" alt="Screenshot 2024-11-12 at 07 24 16" src="https://github.com/user-attachments/assets/903b8f53-cce5-4f1c-b3ab-b037f374a2aa">
