#!/usr/bin/env bash

set -eu
set -o pipefail

# http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

RESET="\033[49m"
BLUE_BG="\033[44m"
GREEN_BG="\033[100m"

_skip() {
  echo -e "Skipping ${GREEN_BG}${1}${RESET}"
}

for file in .* ; do
  if [[ "${file}" == ".git"  || \
        "${file}" == "." || \
        "${file}" == ".." || \
        "${file}" == ".gitignore" || \
        "${file}" == ".gitmodules" \
     ]]; then
    continue
  fi

  source="${THISDIR}/${file}"
  dest="${HOME}/${file}"

  if [[ -h "${dest}" ]] ; then
    realdest="$(readlink "${dest}")"
    if [[ ! "${realdest}" =~ ${THISDIR}.* ]] ; then
      if [[ -e "${source}" ]] ; then
        echo -e "Removing bad link: ${BLUE_BG}${dest}${RESET}"
        unlink "${dest}"
      fi
    fi

    if [[ "${realdest}" == "${source}" || "${HOME}/${realdest}" == "${source}" ]] ; then
      _skip "${dest}"
      continue
    fi
  fi

  if [[ -f "${dest}"  || -h "${dest}" || -d "${dest}" ]]; then
    # Only try to diff files
    if [[ ! -d "${dest}" ]] ; then
      if diff "${dest}" "${source}" ; then
        _skip "${dest}"
        # extremely same
        continue
      fi
    fi

    echo "${dest} already exists and is not a symlink. Overwrite it? y/N"
    read -r answer
    answer="${answer:-N}"
    if [[ "${answer}" == "y" ]]  ; then
      backup="${dest}.bak"
      echo "Overwriting previous file. Saved to ${backup}"
      mv "${dest}" "${backup}"
      ln -sf "${source}" "${dest}"
    fi
  else
    echo -e "Linking ${GREEN_BG}${source}${RESET}\t->\t${BLUE_BG}${dest}${RESET}"
    ln -s "${source}" "${dest}"
  fi
done

mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/src/go"

maybelink () {
  local _from="${1}"
  local _to="${2}"
  [ -e "${_to}" ] && return
  ln -s "${_from}" "${_to}"
}

mkdir -p "${HOME}/.config"
maybelink "${HOME}/.vim" "${HOME}/.config/nvim"

if [[ $(command -v i3 > /dev/null) && ! -d "${HOME}/.config/i3" ]] ; then
  maybelink "${THISDIR}/linux/.i3" "${HOME}/.config/i3"
fi

for file in "${THISDIR}"/bin/* ; do
  maybelink "${file}" "${HOME}/bin"
done

# TODO OS-XX specific hooks
if command -v defaults > /dev/null ; then
  # do stuff from here: https://github.com/herrbischoff/awesome-osx-command-line
  # remove some siulator crap
  xcrun simctl delete unavailable

  # add a stack of recent apps!!
  defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }' && \
    killall Dock

  # enable quit finder
  defaults write com.apple.finder QuitMenuItem -bool true && \
    killall Finder
fi
popd > /dev/null
