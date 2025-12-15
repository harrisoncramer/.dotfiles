#!/bin/zsh

# Add scripts (from scripts directory)
for DIR in ~/scripts/*; do
  PATH="$PATH:$DIR"
done

# Add golang executables
export PATH="$HOME/go/bin:$PATH"

export PATH="$HOME/chariot/chariot/local:$PATH"

# Add tool executables
export PATH="$HOME/.dotfiles/scripts/tool:$PATH"

# Add other executables
export PATH="$HOME/bin:$PATH"

# Added local binaries
export PATH="$HOME/.local/bin:$PATH"

# Configure environments
export PATH="~/nv:$PATH"

# Adding libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Adding Mise stuff
export PATH="~/.local/share/mise/installs/golangci-lint/v2.4.0/golangci-lint-2.4.0-darwin-arm64/:$PATH"

# bun
export PATH="$HOME/.bun/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/harrisoncramer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
