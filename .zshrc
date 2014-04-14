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

if [ -d "$HOME/.rbenv" ] ; then
  export PATH="$PATH:$HOME/.rbenv/bin"
fi

# Load rbenv if available
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

case ${TERM} in
  screen-256color) TERM=xterm-256color
  ;;
esac

export EDITOR=`which vim`

test -r ~/.zshrc.local && . ~/.zshrc.local

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

export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
