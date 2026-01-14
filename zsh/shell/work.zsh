#!/bin/zsh

# For work
gotest () {
  if [ ! "$1" = "" ]; then
    mr go:test "apps/$1" | tool qf
  else
    mr go:test | tool qf
  fi
}

alias mono="cd ~/chariot/chariot"

alias reviews="cd ~/chariot/chariot/.worktrees/reviews"
alias f1="cd ~/chariot/chariot/.worktrees/f1"
alias f2="cd ~/chariot/chariot/.worktrees/f2"
alias agent="cd ~/chariot/chariot/.worktrees/agent"
