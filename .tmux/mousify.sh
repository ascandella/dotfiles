#!/bin/bash

tmux_home="${HOME}/.tmux"

source_conf () {
  tmux source-file "${tmux_home}/${1}.conf"
  exit 0
}

run_for_version () {
  if [[ $(echo "$1 >= $2" | bc) -eq 1 ]] ; then
    source_conf "${3}"
  fi
}

verify_tmux_version() {
  local tmux_version
  tmux_version="$(tmux -V | cut -d' ' -f2)"

  if [[ "${tmux_version}" == "master" ]] ; then
    source_conf "tmux_2.1_plus"
  fi
  run_for_version "${tmux_version}" "2.1" "tmux_2.1_plus"
  run_for_version "${tmux_version}" "1.9" "tmux_1.9_to_2.1"
}

verify_tmux_version
