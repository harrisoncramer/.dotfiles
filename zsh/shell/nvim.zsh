#!/bin/zsh

export NVIM="$HOME/.local/bin/nvim-macos/bin/nvim"
export EDITOR="$NVIM"
alias nvim="$HOME/.local/bin/nvim-macos/bin/nvim"

export NVIM_SOCK_FILE="/tmp/nvim-active-sock"

v () {
  local sock="/tmp/nvim-$$.sock"
  echo "$sock" > "$NVIM_SOCK_FILE"
  if [ "$#" -eq 0 ]; then
    nvim --listen "$sock" .
  else
    nvim --listen "$sock" "$@"
  fi
}

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

