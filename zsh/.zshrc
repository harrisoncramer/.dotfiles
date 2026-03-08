#!/bin/zsh

autoload -Uz compinit
compinit

for file in ~/shell/*.zsh; do
  source "$file"
done

eval "$(mise activate zsh)"
export CGO_ENABLED=1

alias mr="mise run"

if [ "$HOST_NAME" = "harry-work-computer" ]; then
  source ~/.zshrc-work
else
  source ~/.zshrc-personal
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
