_setupOsXDefaults() {
  # TODO OS-XX specific hooks
  if command -v defaults > /dev/null ; then
    # do stuff from here: https://github.com/herrbischoff/awesome-osx-command-line
    # remove some simulator crap
    # xcrun simctl delete unavailable

    # add a stack of recent apps!!
    if ! grep -q "recents-tile" <(defaults read com.apple.dock persistent-others) ; then
      defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
      killall Dock
    fi

    # enable quit finder
    defaults write com.apple.finder QuitMenuItem -bool true
    killall Finder || _internal_error "Unable to killall Finder"
  fi
}

# vim set ft=bash
