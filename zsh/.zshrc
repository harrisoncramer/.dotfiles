#!/bin/zsh

autoload -Uz compinit
compinit

for file in ~/shell/*.zsh; do
  source "$file"
done

eval "$(mise activate zsh)"
export CGO_ENABLED=1

if [ "$HOST_NAME" = "harry-work-computer" ]; then
  source ~/.zshrc-work
else
  source ~/.zshrc-personal
fi
