#!/bin/sh

# link the files
ln -sfv "$HOME"/dotfiles/.zshrc "$HOME"
ln -sfv "$HOME"/dotfiles/.vimrc "$HOME"
ln -sfv "$HOME"/dotfiles/.vim/ "$HOME"
mkdir -p "$HOME"/.config/nvim
ln -sfv "$HOME"/dotfiles/init.vim "$HOME"/.config/nvim
