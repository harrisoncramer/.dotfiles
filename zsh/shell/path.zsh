# Add golang executables
export PATH="$HOME/go/bin:$PATH"

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

# bun
export PATH="$HOME/.bun/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/harrisoncramer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
