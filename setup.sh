#!/bin/bash

ln -fs `pwd`/zshrc $HOME/.zshrc
ln -fs `pwd`/tmux.conf $HOME/.tmux.conf
ln -fs `pwd`/vimrc $HOME/.vimrc
mkdir -p ~/.config/nvim
ln -fs `pwd`/init.vim $HOME/.config/nvim

if [[ -x "$(which nvim)" ]] ; then
    if [[ -x "$(which apt)" ]] ; then
        sudo apt install python3-pip -y
    elif [[ -x "$(which nix-env)" ]] ; then
        nix-env -i python3-pip
    fi
    if [[ -x "$(which pip3)" ]] ; then
        pip3 install neovim
        nvim +NeoBundleInstall +qall
    fi
fi

if [[ -x "$(which git)" ]] ; then
    git config --global push.default simple
    git config --global user.email "tommd@musedev.io"
    git config --global user.name "Thomas M. DuBuisson"
fi
