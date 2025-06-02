#!/bin/zsh

source ~/shell/base.zsh
for file in ~/shell/*.zsh; do
  source "$file"
done

eval "$(mise activate zsh)"
export CGO_ENABLED=1
