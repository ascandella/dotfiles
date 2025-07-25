# shellcheck shell=bash disable=SC1091,SC2155,SC2089,SC2090
# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# End-of-line aka accept history suggestion, a la copilot vim bindings
bindkey '^[m' end-of-line

# Edit command
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^Be" edit-command-line
bindkey "^B^E" edit-command-line

alias -g G=' | grep '
# Allow git commit -m and auto-quote arguments
gcm() {
  git commit -m "$*"
}

ag() {
  if [ -n "$1" ]; then
    local needle="$1"
    shift
    local args=""
    if [[ -n $1 && -z $2 && $1 =~ ^[0-9]+$ ]]; then
      args="-C $1"
      shift
    fi
    # https://github.com/dandavison/delta/issues/1588#issuecomment-e898999756
    # shellcheck disable=SC2086
    rg --json "$needle" ${args} "$@" | delta --tabs=1
  else
    rg
  fi
}

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/171
# Cursor disappearing on move in linux
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
fzf_default_opts+=(
  "--layout=reverse"
  "--info=inline"
  "--height=40%"
  "--multi"
  "--preview='$FZF_PREVIEW'"
  "--preview-window='$FZF_PREVIEW_WINDOW'"
  "--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284"
  "--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf"
  "--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
  "--prompt='∼ '"
  "--pointer='▶'"
  "--marker='✓'"
  "--border='rounded' --border-label='' --preview-window='border-rounded'"
  "--bind '?:toggle-preview'"
  "--bind 'ctrl-a:select-all'"
  "--bind 'ctrl-e:execute(nvim {+} >/dev/tty)'"
)
_command_exists() {
  command -v "${1}" >/dev/null
}
if _command_exists pbcopy; then
  # On macOS, make ^Y yank the selection to the system clipboard. On Linux you can alias pbcopy to `xclip -selection clipboard` or corresponding tool.
  fzf_default_opts+=("--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'")
fi
export FZF_DEFAULT_OPTS=$(printf '%s\n' "${fzf_default_opts[@]}")

if command -v rg >/dev/null; then
  FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
  for ignore in "*.pyc" "idl/*" "vendor/*" "*.age"; do
    FZF_DEFAULT_COMMAND+=" --glob \"!${ignore}\""
  done

  export FZF_DEFAULT_COMMAND
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v ag >/dev/null; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# if _command_exists jenv; then
#   eval "$(jenv init -)"
# fi
#
# Age decrypt
ad() {
  local AGE_IDENTITY="$HOME/.age/identity"
  if [[ ! -f $AGE_IDENTITY ]]; then
    AGE_IDENTITY="$HOME/.ssh/id_ed25519"
  fi
  age -d -i "$AGE_IDENTITY" "$@"
}

# https://github.com/larkery/zsh-histdb?tab=readme-ov-file#integration-with-zsh-autosuggestions
_zsh_autosuggest_strategy_histdb_top() {
  local query="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape "$1")%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape "$PWD")', count(*) desc
        limit 1
    "
  # shellcheck disable=SC2034
  suggestion=$(_histdb_query "$query")
}

# shellcheck disable=SC2034
ZSH_AUTOSUGGEST_STRATEGY=histdb_top

_UNAME=$(uname)
# Workaround for zsh-histdb on macos
if [[ ${_UNAME} == "Darwin" ]]; then
  export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
elif [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# https://github.com/zellij-org/zellij/blob/09689eae8b96ddb95713e6612ec17007ced91306/zellij-utils/assets/completions/comp.zsh
function zr() { zellij run --name "$*" -- zsh -ic "$*"; }
function zrf() { zellij run --name "$*" --floating -- zsh -ic "$*"; }
function zri() { zellij run --name "$*" --in-place -- zsh -ic "$*"; }

kgetsec() {
  local secret_name=$1
  shift
  local namespace="default"
  if [[ -n $1 ]]; then
    namespace="$1"
  fi
  # shellcheck disable=SC2016
  kubectl get secret "$secret_name" -n "$namespace" -o \
    go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
}

update() {
  pushd "${DOTFILES_DIR}" >/dev/null 2>&1
  if [[ ${_UNAME} == "Darwin" ]]; then
    just darwin
  else
    just nixos
  fi
  popd >/dev/null 2>&1
}

autovenv() { (
  set -e
  local pyver="${1:-$(which python3)}"
  if [[ ! -x ${pyver} ]]; then
    echo "Invalid python specified, not executable: ${pyver}"
    return 1
  fi
  local location="${2:-.venv}"
  local systemsitepackages
  # Unless explicitly asked not to, use system site packages. To opt out, pass a
  # second argument
  if [[ -z ${3} || -n ${NO_SYSTEM_SITE_PACKAGES} ]]; then
    systemsitepackages="--system-site-packages"
  fi
  "${pyver}" -m virtualenv "${systemsitepackages}" -p "${pyver}" "${location}"

  # TODO(ai) make this respect the venv location
  ln -s "${XDG_CONFIG_HOME}"/zsh/venv-autoenv.zsh \
    "${AUTOENV_FILE_ENTER:-.autoenv.zsh}"
); }

zn() {
  if [[ -z ${1} ]]; then
    echo "Usage: zn message"
    return 1
  fi
  zellij pipe "zjstatus:notify:${1}"
}

__last_tab_title=""
function change_tab_title() {
  local title="${1}"
  if [[ ${#title} -gt 10 ]]; then
    # Get the last part of the path
    title="${title##*/}"
  fi

  if [[ ${__last_tab_title} != "${title}" ]]; then
    __last_tab_title="${title}"
    command nohup zellij action rename-tab "$title" >/dev/null 2>&1
  fi
}

# https://www.reddit.com/r/zellij/comments/10skez0/does_zellij_support_changing_tabs_name_according/
# and
# https://jcd.pub/2024/06/24/setting-the-zellij-tab-title-to-the-running-process-in-zsh/
set_tab_to_working_dir() {
  tab_name=''
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
    tab_name+=$(git rev-parse --show-prefix)
    tab_name=${tab_name%/}
  else
    tab_name=$PWD
    if [[ $tab_name == "$HOME" ]]; then
      tab_name="~"
    else
      tab_name=${tab_name##*/}
    fi
  fi
  change_tab_title "$tab_name"
}

if [[ -n $ZELLIJ ]]; then
  add-zsh-hook precmd set_tab_to_working_dir
fi
# vi: ft=sh
