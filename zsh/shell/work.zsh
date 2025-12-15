#!/bin/zsh

# For work
test () {
  mr go:test "apps/$1" | tool qf
}

