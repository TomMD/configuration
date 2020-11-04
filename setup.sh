#!/bin/bash

[[ ! ( -f "$HOME/.zshrc" ) ]] && ln -fs `pwd`/zshrc $HOME/.zshrc
[[ ! ( -f "$HOME/.tmux.conf" ) ]] && ln -fs `pwd`/tmux.conf $HOME/.tmux.conf
[[ ! ( -f "$HOME/.vimrc" ) ]] && ln -fs `pwd`/vimrc $HOME/.vimrc
mkdir -p ~/.config/nvim
[[ ! ( -f "$HOME/.config/nvim/init.vim" ) ]] && ln -fs `pwd`/init.vim $HOME/.config/nvim
[[ ! ( -f "$HOME/.config/nvim/settings.json" ) ]] && ln -fs `pwd`/settings.json $HOME/.config/nvim

if [[ -x "$(command -v nvim)" ]] ; then
    if [[ ! ( -x $(command -v pip) )  ]] ; then
        if [[ -x "$(command -v nix-env)" ]] ; then
            nix-env -i python3
        elif [[ -x "$(command -v apt)" ]] ; then
            sudo apt install python3-pip -y
        elif [[ -x "$(command -v brew)" ]] ; then
            brew install python3
        fi
    else
        echo "Using an already-present python/pip"
    fi
    if [[ -x "$(command -v pip3)" ]] ; then
        echo "Setting up neovim plugins"
        pip3 install neovim
        nvim +PlugInstall +qall --headless
        nvim +PlugUpdate +qall --headless
    fi
else
    echo "I suggestion you install neovim then re-run this script."
fi

if [[ ! ( -x "$(command -v ghc)" ) ]] ; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    export PATH=$PATH:$HOME/.ghcup/bin
    ghcup install ghc
    ghcup install hls
    ghcup install cabal-install
else
    echo "GHC is already in the path, I will not install ghcup and tooling automatically."
fi

if [[ -x "$(command -v git)" ]] ; then
    git config --global push.default simple
    git config --global user.email "tommd@muse.dev"
    git config --global user.name "Thomas M. DuBuisson"
fi
