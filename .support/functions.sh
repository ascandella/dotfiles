_debug() {
  [[ -z "${DOTFILES_DEBUG}" ]] && return
  if (( "$#" == 1 )) ; then
    set -- echo -e "$@"
  fi
  "$@"
}

_die() {
  echo -e "${RED_FG}${BOLD}${1}"
  exit "${2:-1}"
}

_skip() {
  [[ -n "${1}" ]] || _die "Skip called without argument"
  [[ -z "${_DOTFILES_VERBOSE}" ]] && return
  echo -e -n "Skipping ${GRAY_BG}$(basename "${1}")${RESET}"
  shift
  set +u
  ([[ -n "${*}" ]] && echo " (${*})") || echo
  set -u
}

# vim set ft=bash
