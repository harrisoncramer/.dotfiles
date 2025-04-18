#!/bin/bash

# Add asdf, set versions
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Source sensitive values
source ~/.zshrc-personal
source ~/.zshrc-work

# Get NVIM path from Other ZSHRC File
export NVIM="$HOME/.local/bin/nvim-macos/bin/nvim"
export EDITOR="$NVIM"
alias nvim="$HOME/.local/bin/nvim-macos/bin/nvim"

v () {
  if [ "$#" -eq 0 ]; then
    nvim .
  else
    $HOME/.local/bin/nvim-macos/bin/nvim "$@"
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
 
# FZF
FZF_RELOAD='reload:rg --column --color=always --smart-case {q} || :'
FZF_OPENER='[ $FZF_SELECT_COUNT -eq 0 ] && /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim {1} +{2} || /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim +cw -q {+f}'
FZF_QUICKFIX_OPENER=''

# Raspberry Pi Utilities
alias pibuild='GOOS=linux GOARCH=arm GOARM=5 go build'
picopy () {
  scp $1 "pi@${PI}:/home/pi"
}

# Add golang executables
export PATH="$HOME/go/bin:$PATH"

# Add tool executables
export PATH="$HOME/.dotfiles/scripts/tool:$PATH"

# Add other executables
export PATH="$HOME/bin:$PATH"

# Added local binaries
export PATH="$HOME/.local/bin:$PATH"

# Configure environments
export PATH="~/nv:$PATH"

# Adding libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export GOPATH="/Users/harrisoncramer/go"

# oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(fast-syntax-highlighting zsh-autosuggestions git git-open fzf zsh-vi-mode)
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
alias g="git"
alias gb="git rev-parse --abbrev-ref HEAD"
alias pr="gh pr view --web"

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
alias so="source"

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

# bun completions
[ -s "/Users/harrisoncramer/.bun/_bun" ] && source "/Users/harrisoncramer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/harrisoncramer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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

# ZSH vim mode use system clipboaard
function zvm_vi_yank() {
	zvm_yank
	echo -n ${CUTBUFFER} | tr -d '\n' | pbcopy
	zvm_exit_visual_mode
}

# AI/LLM
alias chat="sgpt --repl temp"
function answer() {
  echo -n "$@" | sgpt
}

# if [[ -z $GITHUB_TOKEN ]]; then
#   # export GITHUB_TOKEN=$(op item get 'Github API Token' --fields 'personal_access_token' --reveal)
#   export GITHUB_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
# fi
#
# if [[ -z $GITHUB_API_TOKEN ]]; then
#   export GITHUB_API_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
# fi

export GPG_TTY=$(tty)

# Filter lines containing the pattern 'filename:line_number:'
locations() {
    grep -E '^[^:]+:[0-9]+:'
}

uuid() {
  local uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
  echo -n $uuid | pbcopy
  echo "UUID (copied to clipboard): $uuid"
}

iso () {
  date -u +"%Y-%m-%dT%H:%M:%SZ" | tr -d '\n' | pbcopy
}

ucp_stop () {
  docker stop $(docker ps --filter name=supervisor -aq)
  docker stop $(docker ps --filter name=domino -aq)
  docker stop $(docker ps --filter name=clerk -aq)
  docker stop $(docker ps --filter name=sherlock -aq)
}

## GIT ##
alias mono="cd $MONO_DIR"
alias proto="cd $PROTO_DIR"
alias commit="mono && yarn commit"

#####################
## Docker Commands ##
#####################

dc() {
  docker-compose --project-name chariot -f "$MONO_DIR/docker-compose.yml" --env-file "$MONO_DIR/.env" "$@"
}

down() {
  dc down $@
}
purge() {
  dc rm -s -f $@
  CONTAINER=$(docker image ls | grep $@ | awk '{print $3}')
  if [ -n "$CONTAINER" ]; then
    docker rmi  $CONTAINER
  fi
}
stop() {
  dc stop $@
}
start() {
  dc up $@ -d && logs $@
}

logs () {
  logfile="/tmp/logs_buffer.txt"
  rm -f "$logfile"  # Clear previous logs
  touch "$logfile"

  (dc logs --no-log-prefix "$@" -f >> "$logfile" 2>/dev/null) &
  pid=$!

  # Start in tailing mode by default
  tail -n 100000 -f "$logfile" | fzf --tac --no-sort --exact --wrap \
      --bind 'tab:toggle' \
      --bind "ctrl-e:execute:echo {} | awk -F':' '{file=substr(\$1, 2); print \"+\"\$2, ENVIRON[\"MONO_DIR\"]file}' | xargs /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim" \
      --bind 'enter:execute:echo {} | pbcopy' \
      --bind 'esc:abort' \
      --bind 'ctrl-t:reload(cat '"$logfile"')' \
      --bind 'ctrl-r:reload(tail -n 100000 -f '"$logfile"')'

  pkill $pid
}

attach() {
  docker exec -it $@ /bin/bash
}

generate() {
  RUN_PRISMA=false
  if [[ "$1" == "--all" ]]; then
    RUN_PRISMA=true
  fi

  if $RUN_PRISMA; then
    (cd $MONO_DIR/packages/cprisma && yarn prisma-migrate:dev)
  fi

  (cd $MONO_DIR && make generate)
}

restart () {
  # Ensure a service name is provided
  if [ -z "$1" ]; then
    echo "Usage: restart <service> [--hard]"
    exit 1
  fi

  SERVICE=$1
  HARD_RESTART=false

  if [[ "$2" == "--hard" ]]; then
    HARD_RESTART=true
  fi

  # Function to restart the service
  restart_service() {
    if $HARD_RESTART; then
      down $SERVICE 
      start $SERVICE
    else
      stop $SERVICE 
      start $SERVICE
    fi
  }

  # Execute the restart
  restart_service
}

function riverui () {
  if [ -z "$1" ]; then
    echo "Must provide service, e.g. riverui compliance"
    exit 1
  fi

  echo 'Shutting down coauth service, which also runs on :8080'
  SVC=$1
  dc down coauth

  DATABASE_URL="$DEV_DATABASE_URL&search_path=public,$SVC" ~/tools/riverui
}

alias gensql="make -f $MONO_DIR/Makefile -C $MONO_DIR"
alias tunnel="ngrok http --hostname=$NGROK_HOSTNAME $1"

if [ -z "$PROD_DB_URL" ]; then
  PROD_PWD=$(op read op://Development/db_prod/password)
  export PROD_DB_URL="postgresql://chariot:${PROD_PWD}@localhost:5431/chariot"
fi

if [ -z "$STAGING_DB_URL" ]; then
  STAGING_PWD=$(op read op://Development/db_staging/credential)
  export STAGING_DB_URL="postgresql://chariot:${STAGING_PWD}@localhost:5434/chariot"
fi

if [ -z "$PROD_READ_ONLY_DB_URL" ]; then
  PROD_READ_ONLY_PWD=$(op read op://Development/db_prod/password)
  export PROD_READ_ONLY_DB_URL="postgresql://chariot:${PROD_READ_ONLY_PWD}@localhost:5433/chariot"
fi

if [ -z "$SANDBOX_DB_URL" ]; then
  SANDBOX_PWD=$(op read op://Development/db_sandbox/credential)
  export SANDBOX_DB_URL="postgresql://chariot:${SANDBOX_PWD}@localhost:5435/chariot"
fi

if [ -z "$DEV_DATABASE_URL" ]; then
  export DEV_DATABASE_URL="postgresql://chariot:samplepassword@0.0.0.0:5432/chariot?connect_timeout=300"
fi

db_staging () {
  printf "Connecting to staging DB...\n" >&2;\
  ssh -f staging sleep 10 && pgcli -d $STAGING_DB_URL
}

db_prod () {
  printf "Connecting to production DB...be careful!!!\n" >&2;\
  ssh -f prod sleep 10 && pgcli -d $PROD_DB_URL
}

db_prod_read_only () {
  printf "Connecting to read-only production DB...\n" >&2;\
    ssh -f prod_read_only sleep 10 && pgcli -d $PROD_READ_ONLY_DB_URL
}

db_sandbox () {
  printf "Connecting to sandbox DB...\n" >&2;\
  ssh -f sandbox sleep 10 && pgcli -d $SANDBOX_DB_URL
}

db_dev () {
  pgcli -d $DEV_DATABASE_URL
}

# Recent directories: https://junegunn.github.io/fzf/examples/directory-navigation/
. /opt/homebrew/etc/profile.d/z.sh
unalias z 2> /dev/null
z() {
  local dir=$(
    _z 2>&1 |
    fzf --height 40% --layout reverse --info inline \
        --nth 2.. --tac --no-sort --query "$*" \
        --bind 'enter:become:echo {2..}'
  )
  if [ -n "$dir" ]; then
    BUFFER="cd \"$dir\""  # Store command in BUFFER
    zle accept-line       # Execute the command
  fi
  zle reset-prompt
}

# ripgrep->fzf->vim [QUERY]
ff() {
  fzf --disabled --ansi --multi \
      --bind "start:$FZF_RELOAD" --bind "change:$FZF_RELOAD" \
      --bind "enter:become:$FZF_OPENER" \
      --bind "ctrl-e:execute:$FZF_OPENER" \
      --bind 'ctrl-o:toggle-all,ctrl-/:toggle-preview' \
      --bind 'esc:abort' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
}

f() {
  find . -type f | fzf --preview 'bat --style=full --color=always --line-range :500 {}' \
       --bind "enter:become:$FZF_OPENER" \
       --bind "ctrl-e:execute:$FZF_OPENER" \
       --bind "ctrl-l:execute-silent(printf '%s\n' {+} > /tmp/fzf-selected-files)" \
       --preview-window '~4,+{2}+4/3,<80(up)' 
}

autoload -Uz add-zsh-hook

bind_keys() {
  zle -N ff-widget ff
  bindkey -r '^F'
  bindkey '^F' ff-widget

  zle -N search_files f
  bindkey -r '^J'
  bindkey '^J' search_files

  zle -N recent-dirs-widget z
  bindkey -r '^Z'
  bindkey '^Z' recent-dirs-widget
}

add-zsh-hook -d precmd bind_keys
add-zsh-hook precmd bind_keys

# Copilot autocompletion in the shell
eval "$(gh completion -s zsh)"
alias explain="gh copilot explain"
