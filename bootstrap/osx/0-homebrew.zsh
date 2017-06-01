#!/usr/bin/env zsh

if ! command -v brew >/dev/null ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed"
fi
