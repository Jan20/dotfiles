# Dotfiles

A terminal setup built around [fzf](https://github.com/junegunn/fzf) — every tool, command, project, and URL is one or two keystrokes away. No GUI required.

> If you want to learn more about the thought-process behind this setup, visit:
> https://janladicha.de/engineering/efficient-terminal-setup

---

## Table of Contents

- [How It Works](#how-it-works)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Key Bindings](#key-bindings)
- [Aliases](#aliases)
- [Command Lists](#command-lists)
- [Scripts](#scripts)
- [Config](#config)
- [Setup Scripts](#setup-scripts)

---

## How It Works

The core idea is simple: store collections of shell commands, URLs, and notes in plain `.txt` files. Pipe them through `fzf` to fuzzy-search and select. Execute the selection with `eval`.

```zsh
alias g='eval $(cat $DOTFILES_DIR/lists/git.txt | fzf)'
```

Pressing `g` opens an fzf picker of all your git commands. Select one — it runs. The same pattern applies to Docker, Kubernetes, GCloud, npm, Python, Terraform, and more.

Now, by pressing the **f** key, you can search for a directory and cd into it.

<img width="1562" alt="Screenshot 2024-11-13 at 20 47 09" src="https://github.com/user-attachments/assets/654c455e-eb90-43e5-9c78-52be1c4245c0">

We can also bind a key to display and execute commands:

<img width="1562" alt="Screenshot 2024-11-13 at 20 50 11" src="https://github.com/user-attachments/assets/b9ebe4e2-aea0-418d-a63f-9c97436e4f5a">

The concept is not limited to commands — we can store URLs and open them upon selection:

```zsh
alias l='eval $(cat $DOTFILES_DIR/lists/web-pages.txt | fzf)'
```

By pressing **v**, we can quickly adjust the `.zshrc` file, `commands.sh`, and other config files:

<img width="1562" alt="Screenshot 2024-11-12 at 07 23 40" src="https://github.com/user-attachments/assets/5f375efa-d8a8-48a1-9f68-d2f726652799">

<img width="1562" alt="Screenshot 2024-11-12 at 07 24 16" src="https://github.com/user-attachments/assets/903b8f53-cce5-4f1c-b3ab-b037f374a2aa">

---

## Repository Structure

```
dotfiles/
├── commands.sh          # All key bindings and aliases — sourced by .zshrc
├── .env                 # Environment variables (not committed)
├── config/
│   ├── .zshrc           # Shell config (fzf, completion, prompt)
│   ├── .vimrc           # Vim config
│   └── prompt           # Zsh prompt (PS1 + RPROMPT with git branch, docker, time)
├── lists/               # Plain-text command/URL collections for fzf
│   ├── applications.txt
│   ├── agents.txt
│   ├── config.txt
│   ├── docker.txt
│   ├── gcloud.txt
│   ├── general-commands.txt
│   ├── git.txt
│   ├── information.txt
│   ├── kubernetes.txt
│   ├── npm.txt
│   ├── python.txt
│   └── terraform.txt
├── scripts/
│   ├── general/         # Navigation, file ops, dark mode, unzip
│   ├── gcp/             # Google Cloud helpers
│   ├── git/             # Git helpers
│   ├── jira/            # Jira integration
│   └── python/          # Python environment helpers
└── setup/               # One-time install scripts
    ├── install-bat.sh
    ├── install-fzf.sh
    ├── link-vimrc.sh
    └── link-zshrc.sh
```

---

## Getting Started

**Step 1:** Clone the repository

```zsh
mkdir -p ~/Developer && cd ~/Developer
git clone https://github.com/Jan20/dotfiles
```

**Step 2:** Copy and fill in the environment variables

```zsh
cp .env.example .env
vim .env
```

**Step 3:** Install fzf (no brew required)

```zsh
sh setup/install-fzf.sh
```

**Step 4:** Link the zshrc and vimrc

```zsh
sh setup/link-zshrc.sh
sh setup/link-vimrc.sh
```

**Step 5:** Source `commands.sh` in your `~/.zshrc`

```zsh
echo "source $HOME/Developer/dotfiles/commands.sh" >> ~/.zshrc
source ~/.zshrc
```

---

## Environment Variables

Defined in `.env`, sourced automatically by `config/.zshrc`:

| Variable | Description | Example |
|---|---|---|
| `DOTFILES_DIR` | Path to this repository | `~/Developer/dotfiles` |
| `TOOLS_DIR` | Directory for installed tools (fzf, bat) | `~/Developer/tools` |
| `SOURCE_CODE_HOME` | Root of your source code | `~/Developer` |
| `JIRA_DOMAIN` | Jira instance URL | `https://yourorg.atlassian.net` |
| `JIRA_USER` | Jira account email | `you@example.com` |
| `JIRA_TOKEN` | Jira API token | *(from Atlassian account settings)* |
| `JIRA_PROJECT` | Jira project key | `PROJ` |

---

## Key Bindings

| Key | Action |
|---|---|
| `^A` | Open application launcher (fzf) |
| `^D` | Change to a sub-directory (fzf) |
| `^E` | `cd ~/Desktop` |
| `^F` | Change to a project under `$SOURCE_CODE_HOME` (fzf) |
| `^G` | Run a git command (fzf) |
| `^H` | `cd ~/Developer` |
| `^N` | Execute an npm script (fzf) |
| `^O` | Open project in IDE (idea / pycharm / code) |
| `^V` | Run a config command (fzf) |
| `^W` | Jump to a directory under `~/Documents` (fzf) |
| `^Y` | Execute a shell script (fzf) |

---

## Aliases

### Navigation
| Alias | Action |
|---|---|
| `f` | Fuzzy-find and `cd` into a project under `$SOURCE_CODE_HOME` |
| `s` | Fuzzy-find and `cd` into a sub-directory |
| `x` | Fuzzy-find and `cd` into a directory under `~/Documents` |
| `..` | `cd ..` |

### fzf Command Launchers
| Alias | List |
|---|---|
| `d` | Docker commands |
| `g` | Git commands |
| `gg` | Google Cloud commands |
| `i` | Terraform commands |
| `j` | General shell commands |
| `kk` | Kubernetes commands |
| `n` | npm commands |
| `p` | Python commands |
| `ss` | Spotify commands |
| `v` | Config / dotfile commands |

### Tools
| Alias | Action |
|---|---|
| `o` | Open project in IDE |
| `ff` | Fuzzy-find and open a file |
| `hh` | Search shell history with fzf |
| `l` | `tree -C -L2` |
| `c` | `clear` |
| `t` | Open tasks file in vim |
| `u` | Reload `~/.zshrc` |
| `cc` | GitHub Copilot CLI |
| `activate` | Activate Python venv |
| `python` | Alias to `python3` |
| `ls` | `ls --color` |
| `mm` | Toggle docker status in prompt |

---

## Command Lists

Plain `.txt` files in `lists/`. Each line is a shell command — pipe through fzf to select and run.

| File | Contents |
|---|---|
| `applications.txt` | macOS app launcher commands |
| `agents.txt` | AI agent commands |
| `config.txt` | Dotfile editing shortcuts |
| `docker.txt` | Docker commands |
| `gcloud.txt` | Google Cloud CLI commands |
| `general-commands.txt` | Miscellaneous shell commands |
| `git.txt` | Git commands |
| `information.txt` | Notes and reference URLs |
| `kubernetes.txt` | kubectl commands |
| `npm.txt` | npm commands |
| `python.txt` | Python commands |
| `terraform.txt` | Terraform commands |

---

## Scripts

### General (`scripts/general/`)
| Script | Description |
|---|---|
| `select-project.sh` | Fuzzy-find a project under `$SOURCE_CODE_HOME` and `cd` into it |
| `select-dir.sh` | Fuzzy-find a sub-directory under `$PWD` and `cd` into it |
| `open-file.sh` | Fuzzy-find a file and open it |
| `execute-shell-script.sh` | Fuzzy-find and execute a shell script |
| `toggle-dark-mode.sh` | Toggle macOS dark/light mode |
| `unzip-archive.sh` | Fuzzy-find a `.zip` in `$PWD` and extract it |
| `stop-service.sh` | Kill a process on a selected port |

### GCP (`scripts/gcp/`)
| Script | Description |
|---|---|
| `gcp-status.sh` | Display current gcloud account, project, and quota project |
| `set-project.sh` | Switch active gcloud project |
| `cloudrun-logs.sh` | Stream Cloud Run logs |

### Git (`scripts/git/`)
| Script | Description |
|---|---|
| `fuzzy-checkout.sh` | Fuzzy-find and checkout a git branch |
| `check_git_status.sh` | Show git status |

### Jira (`scripts/jira/`)
| Script | Description |
|---|---|
| `show-jira-stories.sh` | Fetch open Jira issues and open the selected one in the browser |

### Python (`scripts/python/`)
| Script | Description |
|---|---|
| `create-environment.sh` | Create and activate a Python venv, upgrade packaging tools |

---

## Config

| File | Description |
|---|---|
| `config/.zshrc` | fzf options, zsh completion, tool PATH setup, prompt source |
| `config/.vimrc` | Vim configuration |
| `config/prompt` | Zsh prompt — left: current path; right: git branch / docker status / time |

### Prompt

The right prompt shows contextual information in priority order:
1. **Git branch** — shown when inside a git repository (cached on directory change for performance)
2. **Docker status** — 🟢🐳 or 🔴🐳, refreshed at most every 10 seconds
3. **Time** — always shown as a fallback

---

## Setup Scripts

One-time scripts for bootstrapping a new machine:

| Script | Description |
|---|---|
| `setup/install-fzf.sh` | Clone and install fzf into `$SOURCE_CODE_HOME/tools/fzf` |
| `setup/install-bat.sh` | Download and install bat into `$SOURCE_CODE_HOME/tools/bat` |
| `setup/link-zshrc.sh` | Append a `source` reference to `config/.zshrc` into `~/.zshrc` |
| `setup/link-vimrc.sh` | Copy `config/.vimrc` to `~/.vimrc` (with backup) |

All setup scripts are idempotent — safe to re-run.
