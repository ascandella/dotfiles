#
# Basic configuration
#

# History
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Immediately append to history file:
setopt INC_APPEND_HISTORY

# Record timestamp in history:
setopt EXTENDED_HISTORY

# Expire duplicate entries first when trimming history:
setopt HIST_EXPIRE_DUPS_FIRST

# Dont record an entry that was just recorded again:
setopt HIST_IGNORE_DUPS

# Delete old recorded entry if new entry is a duplicate:
setopt HIST_IGNORE_ALL_DUPS

# Do not display a line previously found:
setopt HIST_FIND_NO_DUPS

# Dont record an entry starting with a space:
setopt HIST_IGNORE_SPACE

# Dont write duplicate entries in the history file:
setopt HIST_SAVE_NO_DUPS

# Share history between all sessions:
setopt SHARE_HISTORY

# Execute commands using history (e.g.: using !$) immediatel:
unsetopt HIST_VERIFY

setopt appendhistory
setopt autocd
setopt beep
setopt correct
setopt extendedglob
setopt nomatch
setopt nonomatch
setopt sharehistory
setopt interactivecomments

unsetopt notify
zstyle :compinstall filename '$HOME/.zshrc'

DOTFILES="${DOTFILES:-${HOME}/.dotfiles}"

# Zim configuration
zstyle ':zim:zmodule' use 'degit'
ZIM_HOME=~/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Workaround for zsh-histdb on macos
if [[ $(uname) == "Darwin" ]] ; then
  export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
fi

AUTOPAIR_INHIBIT_INIT=1

# Initialize modules.
source ${ZIM_HOME}/init.zsh

case ${TERM} in
  xterm) TERM=xterm-256color ;;
esac

if which nvim >/dev/null ; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

[ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"


# Use emacs keybindings for c-a, c-e etc
bindkey -e
# Unbind "^g" for git-fzf
bindkey -r "^g"

if [[ -d "${DOTFILES}" ]] ; then
  for f in "${DOTFILES}/shell/"* ; do
    . $f
  done
fi

command -v autopair-init >/dev/null && autopair-init

# Allow c-w to backwards word but stop at e.g. path separators
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/171
# Cursor disappearing on move in linux
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

[[ -z "${GPG_TTY}" ]] && export GPG_TTY="$(tty)"
[[ -n "${TMUX}" ]] && gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
