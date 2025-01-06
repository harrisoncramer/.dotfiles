#!/bin/bash

# Get NVIM path from Other ZSHRC File
export NVIM="$HOME/.local/bin/nvim-macos/bin/nvim"
export EDITOR="$NVIM"
alias nvim="$HOME/.local/bin/nvim-macos/bin/nvim"

v () {
  type -p nvm >/dev/null || source "$NVM_DIR/nvm.sh" # Node (lazy loaded) is needed for some Neovim dependencies
  $HOME/.local/bin/nvim-macos/bin/nvim $@
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Raspberry Pi Utilities
alias pibuild='GOOS=linux GOARCH=arm GOARM=5 go build'
picopy () {
  scp $1 "pi@${PI}:/home/pi"
}

# Add golang executables
export PATH="$HOME/go/bin:$PATH"

# Add other executables
export PATH="$HOME/bin:$PATH"

# Added local binaries
export PATH="$HOME/.local/bin:$PATH"

# Configure environments
export PATH="~/nv:$PATH"

export GOPATH="/Users/harrisoncramer/go"

# NVM: Lazily set default NodeJS version (must come before oh-my-zsh plugin)
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

# oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(fast-syntax-highlighting zsh-autosuggestions git git-open fzf zsh-vi-mode zsh-nvm)
source ~/.oh-my-zsh/oh-my-zsh.sh
export ZVM_VI_EDITOR="nvim"

# Fixes conflicts between fzf and zsh-vi-mode
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# Autosuggest accept (instead of right arrow key)
bindkey '^ ' autosuggest-accept

python3 -m venv ~/py_envs
source ~/py_envs/bin/activate

# Creates a new blank Github Repository and Switches into it
project () {
  privateOrPublic="--private"
  if [ "$2" = "--public" ]; then 
    privateOrPublic="--public"
  fi

  mkdir "$1"
  cd "$1"
  git init
  touch README.md
  echo "# ${1}" >> README.md
  mkdir .sessions
  gh repo create "${1}" $privateOrPublic --source=. --remote=origin
  git branch -M main
  git add .
  git commit -m 'Initial commit'
  git push -u origin main
  echo "Success! Repository created."
}

# Git stuff
alias gb="git rev-parse --abbrev-ref HEAD"

stash () {
  if [ "$1" = "pop" ]; then
    git stash pop
  else
    git stash --include-untracked
  fi
}

squash () {
  while IFS= read -r file; do
    ffmpeg -i "$file" -vf "scale=1500:-1" "${file%.*}_squashed.jpg"
  done
}

unreleased () {
  git fetch
  git --no-pager log origin/master..origin/develop --first-parent --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --date=relative --date-order
}

# Aliases
# Autoexpand aliases with tab
zstyle ':completion:*' completer _expand_alias _complete _ignored

# Git aliases
alias gs="git status"
alias gc='git commit -m '
alias gd='git diff'
alias gp='git pull'

alias k='kubectl'
alias dkk='cd ~/Desktop'
alias dotfiles='cd ~/.dotfiles'

# See: https://github.com/venantius/ultra/issues/103
alias lein='LEIN_USE_BOOTCLASSPATH=no lein'

source ~/.zshrc-work
source ~/.zshrc-personal

# Gitlab
# if [[ -z $GITLAB_TOKEN ]]; then
#   export GITLAB_TOKEN=$(op item get GitLab --fields 'Personal Access Token' --reveal)
# fi
#
# bun completions
[ -s "/Users/harrisoncramer/.bun/_bun" ] && source "/Users/harrisoncramer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/harrisoncramer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

function nvims () {
  items=("default" "bare" "gitlab")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt "Neovim config " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    return
  elif [[ $config == "default" ]]; then
    config=""
  fi

  NVIM_APPNAME=$config nvim $@
}

function lk { 
  cd "$(walk "$@")" 
}

# pnpm
export PNPM_HOME="/Users/harrisoncramer/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# gpt
alias gpt="sgpt --repl temp"
