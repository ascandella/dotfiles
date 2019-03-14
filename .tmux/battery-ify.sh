#!/usr/bin/env bash

for cmd in pmset upower acpi ; do
  if command -v "$cmd" > /dev/null ; then
    tmux set -g @plugin 'tmux-plugins/tmux-battery'
    break
  fi
done
