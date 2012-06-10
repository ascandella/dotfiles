#
# Basic configuration
#

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch
unsetopt notify
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

#
# Theme configuration
# Look in ~/.oh-my-zsh/themes/
#

HOST=`hostname -s`
case $HOST {
    simba|banksy) export ZSH_THEME="nanotech" ;;
    crunchy|aiden-u10) export ZSH_THEME="Soliah" ;;
    anton|util[0-9]*) export ZSH_THEME="candy" ;;
    *) export ZSH_THEME="daveverwer" ;;
    # using: daveverwer candy Soliah kennethreitz random
}

#
# Oh-my-zsh configuration
#

export ZSH=$HOME/.oh-my-zsh
export DISABLE_AUTO_UPDATE="true"
plugins=(git brew gem knife rails ruby)
source $ZSH/oh-my-zsh.sh

# This line is to fix some RVM/ZSH interactions for determining the current path
unsetopt auto_name_dirs
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

export PATH=$HOME/src/scripts:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/.rvm/bin

# Sane, without rbenv/rvm
# export PATH=$HOME/src/scripts:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

case ${TERM} in
  screen-256color) TERM=xterm-color
  ;;
esac

test -r ~/.zshrc.$HOST && . ~/.zshrc.$HOST
test -r ~/.zshrc.local && . ~/.zshrc.local

export EDITOR=/usr/bin/vim
export NODE_PATH=/usr/local/lib/node

#
# Load extra functionality
#

if [ -d ~/.dotfiles ] ; then
    export DOTFILES=~/.dotfiles
fi

if [ $DOTFILES ] ; then
    for f in $DOTFILES/shell/* ; do
        . $f
    done
fi
