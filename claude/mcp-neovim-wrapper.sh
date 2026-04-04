#!/bin/bash
export NVIM_SOCKET_PATH="/tmp/nvim-active.sock"
exec "$HOME/.local/share/mise/installs/node/22.0.0/bin/mcp-neovim-server"
