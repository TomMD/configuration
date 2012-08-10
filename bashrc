# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export PATH=/home/tommd/bin:$PATH:/home/tommd/dev/HaLVM/dist/bin

alias ghc74='sudo ln -f -s /usr/local/bin/ghc-7.4.1 /usr/local/bin/ghc; sudo ln -f -s /usr/local/bin/ghc-pkg-7.4.1 /usr/local/bin/ghc-pkg; sudo ln -f -s /usr/local/bin/ghci-7.4.1 /usr/local/bin/ghci'

alias ghc7='sudo ln -f -s /usr/bin/ghc-7.0.4 /usr/local/bin/ghc; sudo ln -f -s /usr/bin/ghc-pkg-7.0.4 /usr/local/bin/ghc-pkg; sudo ln -f -s /usr/bin/ghci-7.0.4 /usr/local/bin/ghci'

alias o='xdg-open'

TERM='xterm-256color'


# User specific aliases and functions
