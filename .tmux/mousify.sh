#!/bin/bash

run_for_version () {
  local tmux_home=~/.tmux
  if [[ $(echo "$1 >= $2" | bc) -eq 1 ]] ; then
    tmux source-file "${tmux_home}/${3}.conf"
    exit 0
  fi
}

verify_tmux_version() {
  local tmux_version="$(tmux -V | cut -d' ' -f2)"

  run_for_version "${tmux_version}" "2.1" "tmux_2.1_plus"
  run_for_version "${tmux_version}" "1.9" "tmux_1.9_to_2.1"
}

verify_tmux_version
