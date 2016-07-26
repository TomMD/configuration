# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Bash like cmd history deduplication
setopt    HIST_IGNORE_ALL_DUPS
setopt    HIST_IGNORE_DUPS
setopt    HIST_IGNORE_SPACE

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

bindkey -M viins 'jk' vi-cmd-mode

setopt rmstarsilent

alias ls='ls -G'
alias o=open
alias top=top -o cpu
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=
export PROMPT='%n@%m %2~%% '
export PATH=/usr/local/bin:$PATH:$HOME/.local/bin:/usr/local/sbin:$HOME/.cabal/bin
if [ -e $HOME/.zshrc_private_stuff ] ; then
    source $HOME/.zshrc_private_stuff
fi
export REPORTTIME=10

alias vi=vim
