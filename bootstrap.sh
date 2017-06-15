#!/usr/bin/env zsh

pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

export DOTFILES="${DOTFILES:-${HOME}/.dotfiles}"

_bootstrap () {
  local file
  for file in "${THISDIR}/bootstrap/${1}/"*.zsh ; do
    # shellcheck disable=SC1090
    source "${file}"
  done
}

case "$(uname)" in
  Darwin)
    _bootstrap osx
    ;;
  Linux)
    _bootstrap linux
    ;;
esac

_bootstrap shared

unset -f _bootstrap
