#!/bin/zsh
alias dkk="cd ~/Desktop"

uuid() {
  local uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
  echo -n $uuid | pbcopy
  echo "UUID (copied to clipboard): $uuid"
}

iso () {
  date -u +"%Y-%m-%dT%H:%M:%SZ" | tr -d '\n' | pbcopy
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
