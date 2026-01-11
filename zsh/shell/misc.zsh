#!/bin/zsh

alias dkk="cd ~/Desktop"

# Mise + Worktrees
mr() {
  if [[ "$1" == wt* ]]; then
    eval "$(mise run "$@")"
  else
    mise run "$@"
  fi
}

wt () {
  eval "$(mise run wt "$@")"
}
