#!/bin/sh

export DOT_FILES_DIR="$(dirname $(readlink "$HOME"/.zshrc))"

# link all the things
ln -sfv "$DOT_FILES_DIR"/.zshrc      "$HOME"/.zshrc
ln -sfv "$DOT_FILES_DIR"/.vimrc      "$HOME"/.vimrc
ln -sfv "$DOT_FILES_DIR"/.vim        "$HOME"/.vim
ln -sfv "$DOT_FILES_DIR"/.phoenix.js "$HOME"/.phoenix.js
