#!/bin/bash

ln -fs `pwd`/zshrc $HOME/.zshrc
ln -fs `pwd`/tmux.conf $HOME/.tmux.conf
ln -fs `pwd`/vimrc $HOME/.vimrc
mkdir -p ~/.config/nvim
ln -fs `pwd`/init.vim $HOME/.config/nvim
ln -fs `pwd`/settings.json $HOME/.config/nvim

if [[ -x "$(which nvim)" ]] ; then
    if [[ -x "$(command -v apt)" ]] ; then
        sudo apt install python3-pip -y
    elif [[ -x "$(command -v nix-env)" ]] ; then
        nix-env -i python3-pip
    elif [[ -x "$(command -v brew)" ]] ; then
        brew install python3
    fi
    if [[ -x "$(command -v pip3)" ]] ; then
        pip3 install neovim
        nvim +PlugInstall +qall --headless
        nvim +PlugUpdate +qall --headless
    fi
fi

if [[ -x "$(which git)" ]] ; then
    git config --global push.default simple
    git config --global user.email "tommd@muse.dev"
    git config --global user.name "Thomas M. DuBuisson"
fi
