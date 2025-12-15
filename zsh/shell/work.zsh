#!/bin/zsh

# For work
test () {
  if [ ! "$1" = "" ]; then
    mr go:test "apps/$1" | tool qf
  else
    mr go:test | tool qf
  fi
}

