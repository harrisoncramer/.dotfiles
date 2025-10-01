#!/bin/zsh

uuid() {
  local uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
  echo -n $uuid | pbcopy
  echo "UUID (copied to clipboard): $uuid"
}
