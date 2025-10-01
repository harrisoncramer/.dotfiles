#!/bin/zsh
alias dkk="cd ~/Desktop"
alias mr="mise run"

for file in ~/shell/utils/*; do
  source "$file"
done
