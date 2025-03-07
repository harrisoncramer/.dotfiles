# This is needed by Neovim in order to find NVM and NPM
DIR="$HOME/.nvm/versions/node"
export PATH="$DIR/$(ls $DIR | tail -n1)/bin:$PATH"
