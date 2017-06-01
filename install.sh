#!/usr/bin/env bash

set -eu
set -o pipefail

# http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

SUPPORT="${THISDIR}/.support"
for supp in "${SUPPORT}"/* ; do
  # shellcheck disable=SC1090
  source "${supp}"
done

_die() {
  echo -e "${RED_FG}${BOLD}${1}"
  exit "${2:-1}"
}

_skip() {
  [[ -n "${1}" ]] || _die "Skip called without argument"
  echo -e -n "Skipping ${GRAY_BG}$(basename "${1}")${RESET}"
  shift
  set +u
  ([[ -n "${*}" ]] && echo " (${*})") || echo
  set -u
}

_printAndLink () {
  local source="$1"
  local dest="$2"
  echo -e "Linking  ${GRAY_BG}${source}${RESET} -> ${BLUE_BG}${dest}${RESET}"
  ln -s "${source}" "${dest}"
}


UNINTERESTING=". .. .git .gitignore .gitmodules .vim.configure .support
.DS_Store"

_scanAndLink () {
  echo -e "Scanning ${BLUE_BG}${1}${RESET}"
  local file
  for file in "${1}"/${2:-.*} ; do
    local realfile boring
    realfile="$(basename "${file}")"
    for boring in ${UNINTERESTING} ; do
      if [[ "${realfile}" == "${boring}" ]] ; then
        _skip "${boring}" "support file"
        continue 2
      fi
    done

    local source="${file}"
    dest="${HOME}/${3:-}$(basename "${file}")"

    if [[ -h "${dest}" ]] ; then
      realdest="$(readlink "${dest}")"
      if [[ ! "${realdest}" =~ ${THISDIR}.* ]] ; then
        if [[ ! -e "${source}" ]] ; then
          echo -e "Removing bad link: ${BOLD}${BLUE_BG}${dest}${RESET}"
          unlink "${dest}"
        fi
      fi

      if [[ "${realdest}" == "${source}" || "${HOME}/${realdest}" == "${source}" ]] ; then
        _skip "${dest}"
        continue
      fi
    fi

    if [[ -f "${dest}"  || -h "${dest}" || -d "${dest}" ]]; then
      local skipMe=
      if [[ ! -e "${dest}" ]] ; then
        echo -e "${BOLD}${RED_FG}${dest}${RESET} appears to be a broken symmlink. ${BOLD}Removing...${RESET}"
        skipMe="yass"
        unlink "${dest}"
        ln -s "${source}" "${dest}"
        continue
      fi
      # Only try to diff files
      if [[ -z "${skipMe}" && ! -d "${dest}" ]] ; then
        if diff "${dest}" "${source}" ; then
          _skip "${dest}"
          # extremely same
          continue
        fi
      fi

      echo -e -n "${BOLD}${RED_FG}${dest}${RESET} already exists and is not a symlink. Overwrite it? y/N: "
      read -r answer
      answer="${answer:-N}"
      if [[ "${answer}" == "y" ]]  ; then
        backup="${dest}.bak"
        echo -e "${RED_FG}Overwriting previous file. Saved to ${backup}${RESET}"
        mv "${dest}" "${backup}"
        ln -sf "${source}" "${dest}"
      fi
    else
      _printAndLink "${source}" "${dest}"
    fi
  done
}

mkdir -p "${HOME}/src"

# TODO break out macOS and Linux into their own dirs
_scanAndLink "${THISDIR}"
_scanAndLink "${THISDIR}/dotconfig" "*" ".config/"

case "$(uname)" in
  Darwin)
    OSX_FONTS="${HOME}/src/fonts"
    if [[ ! -d "${OSX_FONTS}" ]] ; then
      git clone "https://github.com/powerline/fonts.git" "${OSX_FONTS}"
      pushd "${OSX_FONTS}"
      ./install.sh
      popd
    fi
    _scanAndLink "${THISDIR}/to-install/osx"
    # TODO not working yet
    # _scanAndLink "${THISDIR}/to-install/osx/bin" "*" "bin/"
    ;;
  Linux)
    _scanAndLink "${THISDIR}/to-install/linux"
    _scanAndLink "${THISDIR}/to-install/linux/bin" "*" "bin/"
    ;;
esac

mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/src/go"

maybelink () {
  local _from="${1}"
  local _to="${2}"
  [ -e "${_to}" ] || _printAndLink "${_from}" "${_to}"
}

mkdir -p "${HOME}/.config"
maybelink "${HOME}/.vim" "${HOME}/.config/nvim"

if [[ $(command -v i3 > /dev/null) && ! -d "${HOME}/.config/i3" ]] ; then
  maybelink "${THISDIR}/linux/.i3" "${HOME}/.config/i3"
fi

for file in "${THISDIR}"/bin/* ; do
  maybelink "${file}" "${HOME}/bin/$(basename "${file}")"
done

FZF_INSTALL="${HOME}/.fzf/install"
FZF_BIN="${HOME}/.fzf/bin/fzf"
if [[ ! -x "${FZF_BIN}" && -x "${FZF_INSTALL}" ]] ; then
  echo -e "Auto-installing${RESET} ${BLUE_BG}fzf${RESET}"
  "${FZF_INSTALL}" --no-update-rc --completion --key-bindings
fi

# TODO OS-XX specific hooks
if command -v defaults > /dev/null ; then
  # do stuff from here: https://github.com/herrbischoff/awesome-osx-command-line
  # remove some siulator crap
  xcrun simctl delete unavailable

  # add a stack of recent apps!!
  if ! grep -q "recents-tile" <(defaults read com.apple.dock persistent-others) ; then
    defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
    killall Dock
  fi

  # enable quit finder
  defaults write com.apple.finder QuitMenuItem -bool true
  killall Finder || _internal_error "Unable to killall Finder"
fi

CHANGED_FILES=""
if [[ -n "${PREVIOUS_DOTFILES:-}" ]] ; then
  CHANGED_FILES="$(git log --pretty='format:' --name-only "${PREVIOUS_DOTFILES}"..HEAD | sort | uniq)"
fi


files_changed () {
  if [[ -z "${1}" ]] ; then
    _internal_error "Bad usage of files_changed: need argument"
    return 1
  fi

  if [[ -z "${PREVIOUS_DOTFILES:-}" ]] ; then
    echo "1"
    return
  fi
  if [[ "${CHANGED_FILES}" =~ $1 ]] ; then
    echo "1"
    return
  fi
  echo "0"
}

if [[ $(files_changed ".gitmodules") == "1" ]] ; then
  echo
  echo "Detected update to git submodules, updating"
  git submodule update --init --recursive
  echo -e "${BLUE_BG}Done${RESET}"
fi


if [[ $(files_changed ".vimrc") == "1" ]] ; then
  # TODO pass vars from autoupdate to only run if .vimrc has changed
  if command -v vim >/dev/null ; then
    echo "Detected change to .vimrc, updating vim plugins"
    vim +PlugInstall +PlugClean +qall
    echo -e "${BLUE_BG}Done${RESET}"
  fi
fi

popd > /dev/null
