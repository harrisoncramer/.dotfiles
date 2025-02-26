# This is needed by Neovim in order to find NVM and NPM
export PATH="$NVM_DIR/versions/node/$(ls "$NVM_DIR/versions/node" | tail -n1)/bin:$PATH"
