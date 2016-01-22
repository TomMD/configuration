#!/bin/bash

ln -s `pwd`/zshrc $HOME/.zshrc
ln -s `pwd`/tmux.conf $HOME/.tmux.conf
ln -s `pwd`/vimrc $HOME/.vimrc
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
git clone https:/github.com/VundleVim/Vundle.vim.git
vim +PluginInstall -qall
