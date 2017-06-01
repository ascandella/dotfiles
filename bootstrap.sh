#!/usr/bin/env bash

pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

_bootstrap () {
  local file
  for file in "${THISDIR}/bootstrap/${1}/"* ; do
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

unset -f _bootstrap
