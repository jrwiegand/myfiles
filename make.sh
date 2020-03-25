#!/bin/sh

export DOT_FILES_DIR="$(dirname $(readlink "$HOME"/.zshrc))"

# link all the things
ln -sfv "$DOT_FILES_DIR"/dotfiles/zshrc      "$HOME"/.zshrc
ln -sfv "$DOT_FILES_DIR"/dotfiles/vimrc      "$HOME"/.vimrc
ln -sfv "$DOT_FILES_DIR"/dotfiles/vim/       "$HOME"/.vim/
ln -sfv "$DOT_FILES_DIR"/dotfiles/phoenix.js "$HOME"/.phoenix.js
