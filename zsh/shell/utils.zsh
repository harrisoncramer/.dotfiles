#!/bin/zsh
alias dkk="cd ~/Desktop"
alias mr="mise run"

uuid() {
  local uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
  echo -n $uuid | pbcopy
  echo "UUID (copied to clipboard): $uuid"
}

iso () {
  date -u +"%Y-%m-%dT%H:%M:%SZ" | tr -d '\n' | pbcopy
}
