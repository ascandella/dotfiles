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
setopt interactivecomments

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

# if [ -d "$HOME/.rbenv" ] ; then
#   export PATH="$PATH:$HOME/.rbenv/bin"
# fi

# Load rbenv if available
# if which rbenv > /dev/null; then
#   eval "$(rbenv init -)"
# fi

case ${TERM} in
  screen-256color) TERM=xterm-256color ;;
  xterm) TERM=xterm-256color ;;
esac

if which nvim >/dev/null ; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

[ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"

#
# Load extra functionality
#

DOTFILES="${DOTFILES:-${HOME}/.dotfiles}"

ANTIGEN_SOURCE="${DOTFILES}/ext/antigen/antigen.zsh"
if [[ -s "${ANTIGEN_SOURCE}" ]] ; then
  . "${ANTIGEN_SOURCE}"
  # This gets cached, doesn't run every time
  antigen-bundle Tarrasch/zsh-autoenv

  # TODO consider smart antigen init
  antigen apply
fi
unset ANTIGEN_SOURCE


SUPPORT="${DOTFILES}/.support"
if [[ -d ${SUPPORT} ]] ; then
  for supp in "${SUPPORT}"/* ; do
    # shellcheck disable=SC1090
    source "${supp}"
  done
fi

if [[ -d "${DOTFILES}" ]] ; then
  for f in "${DOTFILES}/shell/"* ; do
    . $f
  done
fi

test -r ~/.zshrc.local && . ~/.zshrc.local

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

[[ -z "${GPG_TTY}" ]] && export GPG_TTY="$(tty)"
