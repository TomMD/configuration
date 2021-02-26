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

if [ "`uname`" = "Darwin" ] ; then
    alias ls='ls -G'
    alias o=open
    alias top='top -o cpu'
    alias md5sum='md5 -r'
else
    alias ls='ls --color -G'
    alias o=xdg-open
fi
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=
export PROMPT='%n@%m %2~%% '
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/Library/Python/2.7/bin:/usr/local/sbin:$HOME/.cabal/bin
export REPORTTIME=1
alias vi=nvim
bindkey '^R' history-incremental-search-backward
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# GPG Junk
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
# export VAGRANT_DEFAULT_PROVIDER=ovirt3
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi

# Nix, ghcup
export PATH=$HOME/.ghcup/bin:$PATH:$HOME/.nix-profile/bin
export EDITOR=nvim

if [ -e "$HOME/.zshrc_private_stuff" ]; then
     source $HOME/.zshrc_private_stuff
 fi

runHaskTagsVim() {
      # use --etags instead of --ctags for emacs
      hasktags --ctags .
}
mkTags() {
    runHaskTagsVim
}

KEYTIMEOUT=0
export TERM=screen-256color

# For ghc as packaged by ghchq. Might help for nix packaging too
export LIBRARY_PATH=/usr/lib

# Completions
fpath=($HOME/dev/configuration/zsh-completions/src $fpath)

if [[ -f $HOME/ghcup/env ]] ; then
    source "$HOME/.ghcup/env"
fi

if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi

if [ -f "$HOME/.nix-profile/etc/ssl/certs/ca-bundle.crt" ] ; then
    export SSL_CERT_FILE=~/.nix-profile/etc/ssl/certs/ca-bundle.crt
fi

 if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] ; then
     source $HOME/.nix-profile/etc/profile.d/nix.sh
 fi

 export TF_VAR_pgp_key=`gpg --export 'tommd@muse.dev' | base64`

 alias cb="cabal build --builddir=build"
 alias cr="cabal repl --builddir=build"
 alias ce="cabal exec --builddir=build"
 alias ct="cabal test --builddir=build"
 alias gb="git branch | grep '*'"
 alias museit='docker run --rm -it -v $(pwd):/code musedev/analyst analyst -t /code -C $(git rev-parse HEAD) -l debug'

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

function gitapt() {
    repo=$1
    shift
    dir=$(mktemp -d)
    cd $dir
    git clone git@github.com:TomMD/$repo $dir
    pushd $dir
    mkdir .muse
    echo 'setup = ".muse/setup.sh"' >> .muse/config.toml
    echo '#!/usr/bin/env bash' >> .muse/setup.sh
    echo 'apt update && apt install -y $*' >> .muse/setup.sh
    git add .muse
    git commit -m 'Add muse script to install deps'
    git push
    popd
}
