# Dotfiles

This repository contains all of my dotfiles and global configuration.

## Dependencies

The `brew` package manager.

## Setup

I'm using <a href="https://www.gnu.org/software/stow/">stow</a> to automatically symlink the relevant configuration folders to their correct locations.

This is all configured via a `./install` script. When it's run with the `--all` command, the script will:

- Install <a href="https://www.gnu.org/software/stow/">stow</a> to automatically symlink the relevant configuration folders to their correct locations.
- Install <a href="https://github.com/jdx/mise">mise</a> to install and manage languages.
- Install and link all dependencies

The installer is designed to be idempotent, meaning it can be run multiple times and will still work.

Individual components can be installed with flags like `--brew`, `--npm`, `--go`, `--nvim`, `--claude`, and `--tmux`.

## Tools

- **alacritty** — GPU-accelerated terminal with Kanagawa Wave theme and JetBrainsMono Nerd Font
- **bat** — Syntax-highlighted `cat` replacement, themed to match alacritty
- **claude** — <a href="https://github.com/anthropics/claude-code">Claude Code</a> settings with tmux status bar integration via hooks
- **gh-dash** — <a href="https://github.com/dlvhdr/gh-dash">GitHub dashboard</a> TUI for PRs and issues with custom keybindings and delta diffs
- **git** — Global config, aliases, and a pre-push hook that builds Go binaries and verifies DB state
- **k9s** — <a href="https://github.com/derailed/k9s">Kubernetes TUI</a> pointing at staging/production clusters
- **karabiner** — Remaps Option+hjkl to arrow keys system-wide
- **nv** — Shell scripts to inject AWS credentials from <a href="https://developer.1password.com/docs/cli/">1Password CLI</a>
- **p10k** — <a href="https://github.com/romkatv/powerlevel10k">Powerlevel10k</a> prompt with instant prompt and kubecontext/AWS segments
- **pgcli** — <a href="https://www.pgcli.com/">pgcli</a> with vi mode, destructive-query warnings, and named queries
- **scripts** — Bash utilities (`killport`, `uuid`, `iso`, `git-recent`, etc.) and a Go health-monitor that updates tmux
- **tmux** — Session manager with `Ctrl-]` prefix, vim pane navigation, and a Claude status indicator
- **zsh** — <a href="https://ohmyz.sh/">Oh My Zsh</a> with fzf-tab, fast-syntax-highlighting, vi-mode, and per-host work/personal config

## Environment

Shell config is split between personal and work profiles detected by hostname. Secrets (database URLs, API tokens, AWS keys) are fetched at shell init via the <a href="https://developer.1password.com/docs/cli/">1Password CLI</a>.
