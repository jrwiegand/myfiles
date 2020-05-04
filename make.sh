#!/bin/sh

export DOT_FILES_DIR="$(dirname $(readlink "$HOME"/.zshrc))"

if [ ! -d "$HOME"/.nvm ]; then
    mkdir "$HOME"/.nvm
fi

# link all the things
ln -sfv "$DOT_FILES_DIR"/.zshrc            "$HOME"/.zshrc
ln -sfv "$DOT_FILES_DIR"/.vimrc            "$HOME"/.vimrc
ln -sfv "$DOT_FILES_DIR"/.vim              "$HOME"/.vim
ln -sfv "$DOT_FILES_DIR"/.phoenix.js       "$HOME"/.phoenix.js
ln -sfv "$DOT_FILES_DIR"/default-packgages "$HOME/".nvm/default-packages
