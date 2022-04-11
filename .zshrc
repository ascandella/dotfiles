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
setopt extendedglob
setopt nomatch
setopt nonomatch
setopt sharehistory
setopt interactivecomments

unsetopt notify
zstyle :compinstall filename '$HOME/.zshrc'

# Need patched nerd fonts for this
POWERLEVEL9K_MODE='nerdfont-complete'

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
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# if [ -d "$HOME/.rbenv" ] ; then
#   export PATH="$PATH:$HOME/.rbenv/bin"
# fi

# Load rbenv if available
# if which rbenv > /dev/null; then
#   eval "$(rbenv init -)"
# fi

case ${TERM} in
  xterm) TERM=xterm-256color ;;
esac

if which nvim >/dev/null ; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

[ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"

# https://github.com/spaceship-prompt/spaceship-prompt/blob/eed57700e30a36993e9107c8f3259289ac6828bd/docs/options.md
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  gradle        # Gradle section
  maven         # Maven section
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  aws           # Amazon Web Services section
  gcloud        # Google Cloud Platform section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  ibmcloud      # IBM Cloud section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)


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

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/171
# Cursor disappearing on move in linux
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

[[ -z "${GPG_TTY}" ]] && export GPG_TTY="$(tty)"
[[ -n "${TMUX}" ]] && gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
