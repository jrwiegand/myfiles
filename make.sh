#!/bin/sh

export REPO_DIR="$(dirname $(readlink "$HOME"/.zshrc))"

if [ ! -d "$HOME"/.nvm ]; then
    mkdir "$HOME"/.nvm
fi

# link all the things
ln -sfv "$REPO_DIR"/.zshrc            "$HOME"/.zshrc
ln -sfv "$REPO_DIR"/.vimrc            "$HOME"/.vimrc
ln -sfv "$REPO_DIR"/.vim              "$HOME"/.vim
ln -sfv "$REPO_DIR"/.phoenix.js       "$HOME"/.phoenix.js
ln -sfv "$REPO_DIR"/default-packgages "$HOME/".nvm/default-packages
