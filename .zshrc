#
# Basic configuration
#

HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt autocd
setopt beep
setopt correct
setopt correctall
setopt extendedglob
setopt histignorealldups
setopt nomatch
setopt nonomatch
setopt sharehistory

unsetopt notify
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

#
# Load Prezto
#
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#
# Theme configuration
# Look in ~/.oh-my-zsh/themes/
#

# HOST=`hostname -s`
# case $HOST {
#     simba|banksy|aiden-air) export ZSH_THEME="nanotech" ;;
#     crunchy|aiden-u10)      export ZSH_THEME="Soliah" ;;
#     alai)                   export ZSH_THEME="candy" ;;
#     *)                      export ZSH_THEME="daveverwer" ;;
#     # using: daveverwer candy Soliah kennethreitz random
# }

#
# Oh-my-zsh configuration
#

# export ZSH=$HOME/.oh-my-zsh
# export DISABLE_AUTO_UPDATE="true"
# plugins=(git gem knife rails ruby zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh


# Load rbenv if available
if which rbenv > /dev/null; then
    eval "$(rbenv init -)"
fi

case ${TERM} in
  screen-256color) TERM=xterm-color
  ;;
esac

export EDITOR=`which vim`

test -r ~/.zshrc.local && . ~/.zshrc.local

NODE_PATH=/usr/local/lib/node
if [ -d $NODE_PATH ] ; then
  export NODE_PATH
fi

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
