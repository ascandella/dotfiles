#!/usr/bin/env bash

set -eu
set -o pipefail

# http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"
DOTFILES_DEBUG="${DOTFILES_DEBUG:-}"

_DOTFILES_VERBOSE="${VERBOSE:-}"
if [[ "$#" -gt 0 ]] ; then
  if [[ "${1}" == "-v" || "${1}" == "--verbose" ]] ; then
    _DOTFILES_VERBOSE="1"
  fi
fi
export _DOTFILES_VERBOSE

SUPPORT="${THISDIR}/.support"
for supp in "${SUPPORT}"/* ; do
  # shellcheck disable=SC1090
  source "${supp}"
done

_maybeLink () {
  local _from="${1}"
  local _to="${2}"
  local _user="${3}"
  if [[ -d ${_from} ]] ; then
    _debug echo "Not searching for command directive for directory"
    _printAndLink "${_from}" "${_to}" "${_user}"
  elif ! [[ -e "${_to}" ]] ; then
    local _header
    _header="$(head -n 2 "${_from}")"
    local _headerFiltered
    _headerFiltered="$(grep -e "needs .\\+ (ai)" <(echo "${_header}") || true)"
    _debug "Filtered header ${_headerFiltered}"
    if [[ -n "${_headerFiltered}" ]] ; then
      _debug "Found command directive in ${_from}"
      local _cmd
      # shellcheck disable=SC2001
      _cmd="$(echo "${_headerFiltered}" | sed 's/.*needs \(.*\) .*/\1/')"
      _debug "${_from} needs command ${_cmd:-}"
      if [[ -n "${_cmd}" ]] && command -v "${_cmd}" >/dev/null ; then
        _debug "Command ${GRAY_BG}${_cmd:-}${RESET} found, linking ${_to}"
        _printAndLink "${_from}" "${_to}" "${_user}"
      else
        echo -e "Command ${BOLD}${RED_FG}${_cmd}${RESET} not found, skipping ${GRAY_BG}${_to}${RESET}"
      fi
    else
      _printAndLink "${_from}" "${_to}" "${_user}"
    fi
  else
    _debug "${GRAY_BG}${_to}${RESET} already exists"
  fi
}

_askForConfirmation () {
  local msg="${1}"
  local default="${2:-N}"
  local yn="y/N"
  if [[ "${default}" == "Y" ]] ; then
    yn="Y/n"
  fi

  echo -e -n "${msg} ${yn} "
  local answer
  read -r answer
  if [[ $(echo "${answer:-${default}}" | tr y Y) == "Y" ]] ; then
    return 0
  else
    return 1
  fi
}


UNINTERESTING=". .. .git .gitignore .gitmodules .vim.configure .support .DS_Store .test-helpers .travis.yml .git-hooks .luacheckrc"

# Darwin :'(
_readlink="readlink"
set +e
_has_readlink_f="$(readlink --help 2>/dev/null | grep -- -f)"
set -e
if [[ -n "${_has_readlink_f}" ]] ; then
  _readlink="readlink -f"
fi

_alreadyinstalled=()
_markInstalled () {
  _alreadyinstalled+=("${1}")
  echo "Already installed \"${_alreadyinstalled[*]}\""
}
_installedByUs () {
  set +u
  if [[ "${_alreadyinstalled[*]}" =~ ${1} ]] ; then
    echo "${1} already installed, skipping"
  fi
  set -u
  return 0
}

_scanAndLink () {
  local inputDir="${THISDIR}"
  [[ -n "${1:-}" ]] && inputDir="${inputDir}/${1}"
  if [[ -n "${_DOTFILES_VERBOSE}" ]] ; then
    echo -e "Scanning ${BLUE_BG}${inputDir}${RESET}"
  fi
  if [[ ! -d ${inputDir} ]] ; then
    _internal_error "No such directory: ${inputDir}"
    return
  fi
  local file

  local user="${4:-}"
  local needsSudo=""
  if [[ -n "${3:-}" && "${3}" = /*  && ! -d "${3}" ]] ; then
    echo -e "${RED_FG}Destination ${3} does not exist, skipping${RESET}"
    return
  fi
  if [[ -n "${user}" && -d "${3}" ]] ; then
    local destbase="${3}"
    needsSudo="yes"
  else
    local destbase="${HOME}/${3:-}"
  fi
  readonly destbase
  # Cleanup old symlinks
  local existingLink
  while IFS= read -r -d '' existingLink ; do
    _maybeCleanupSymlink "${existingLink}"
  done < <(find "${destbase}" -maxdepth 1 -type l -print0)

  for file in "${inputDir}"/${2:-.*} ; do
    local realfile boring
    realfile="$(basename "${file}")"
    for boring in ${UNINTERESTING} ; do
      if [[ "${realfile}" == "${boring}" ]] ; then
        _debug _skip "${boring}" "support file"
        continue 2
      fi
    done

    local source="${file}"
    local dest
    dest="${destbase}$(basename "${file}")"

    if _installedByUs "${dest}" ; then
      _debug "Skipping already installed ${dest}"
    fi

    if [[ -h "${dest}" ]] ; then
      _debug "Possibly cleaning up symlink ${dest}"
      _maybeCleanupSymlink "${dest}"

      local realdest
      set +e
      realdest="$(${_readlink} "${dest}")"
      set -e
      if [[ -z "${realdest}" ]] ; then
        _skip "${dest}"
        continue
      fi
      local realsource="${source}"
      if [[ -h "${source}" && -n "${_has_readlink_f}" ]] ; then
        realsource="$(${_readlink} "${source}")"
      fi
      if [[ "${realdest}" == "${realsource}" || "${HOME}/${realdest}" == "${realsource}" ]] ; then
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
        _maybLink "${source}" "${dest}" "${user}"
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

      if [[ -n "${needsSudo}" ]] ; then
        echo
        echo -e "${BOLD}${RED_FG}${destbase}${RESET} is outside of home path${RESET}"
        echo "This may require sudo"
        echo
      fi

      echo -e "${GRAY_BG}$(file "${dest}")${RESET}"
      local _confirm="${BOLD}${RED_FG}${dest}${RESET} already exists and is not a symlink. ${BOLD}Overwrite it?${RESET}:"
      if _askForConfirmation "${_confirm}" ; then
        if _askForConfirmation "Create backup?" "Y" ; then
          backup="${dest}.bak"
          echo -e "${RED_FG}Overwriting previous file. Saved to ${backup}${RESET}"
          mv "${dest}" "${backup}"
          _markInstalled "${dest}"
        else
          if [[ -d "${dest}" ]] ; then
            rm -r "${dest}"
          else
            rm "${dest}"
          fi
        fi
        ln -sf "${source}" "${dest}"
        _markInstalled "${dest}"
      fi
    else
      _debug "Normal link: ${source} -> ${dest}"
      _maybeLink "${source}" "${dest}" "${user}"
    fi
  done

  if [[ -n "${_DOTFILES_VERBOSE}" ]] ; then
    echo
  fi
}

mkdir -p "${HOME}/src"
mkdir -p "${HOME}/.local/bin"

_scanAndLink
_scanAndLink "dotconfig" "*" ".config/"
_scanAndLink "bin" "*" ".local/bin/"
_scanAndLink "ext/git-fuzzy/bin" "*" ".local/bin/"

_hostname="$(hostname)"
_hostdir="to-install/_byhost/${_hostname}"
if [[ -d "${_hostdir}" ]] ; then
  if [[ -n "${_DOTFILES_VERBOSE}" ]] ; then
    echo -e "Installing ${RED_FG}host '${_hostname}'${RESET} specific files"
    echo
  fi
  _scanAndLink "${_hostdir}" ".*"
  _scanAndLink "${_hostdir}/dotconfig" "*" ".config/"
  echo
fi

case "$(uname)" in
  Darwin)
    _scanAndLink "to-install/osx"
    # No macOS binaries yet
    _scanAndLink "to-install/osx/bin" "*" ".local/bin/"
    _scanAndLink "to-install/osx/appsupport/ubersicht/widgets" "*" "Library/Application Support/Übersicht/widgets/"
    _scanAndLink "library/VSCode/User" "*" "Library/Application Support/Code/User/"
    _scanAndLink "library/Preferences/org.dystroy.broot" "*" "Library/Preferences/org.dystroy.broot/"
    _scanAndLink "osx" "DefaultKeyBinding.dict" "Library/KeyBindings/"
    _setupOsXDefaults
    ;;

  Linux)
    _scanAndLink "to-install/linux"
    _scanAndLink "to-install/linux/dotconfig" "*" ".config/"
    _scanAndLink "to-install/linux/dotconfig" ".*" ".config/"
    _scanAndLink "to-install/linux/applications" "*" ".local/share/applications/"
    _scanAndLink "to-install/linux/bin" "*" ".local/bin/"
    _scanAndLink "to-install/linux/systemd-user" "*" ".config/systemd/user/"
    _scanAndLink "to-install/linux/autokey" "*" ".config/autokey/data/"
    _scanAndLink "to-install/linux/plasma-env" "*" ".config/plasma-workspace/env/"
    _scanAndLink "library/VSCode/User" "*" ".config/Code/User/"
    _scanAndLink "library/Preferences/org.dystroy.broot" "*.toml" ".config/org.dystroy.broot/"
    ;;
esac

mkdir -p "${HOME}/src/go"
mkdir -p "${HOME}/.config"

FZF_INSTALL="${HOME}/.fzf/install"
FZF_BIN="${HOME}/.fzf/bin/fzf"
if [[ ! -x "${FZF_BIN}" && -x "${FZF_INSTALL}" ]] ; then
  echo -e "Auto-installing${RESET} ${BLUE_BG}fzf${RESET}"
  "${FZF_INSTALL}" --no-update-rc --completion --key-bindings
fi

CHANGED_FILES=""
PREVIOUS_SHA="${HOME}/.config/.installsha"
if [[ -z "${_PREVIOUS_DOTFILES:-}" && -e "${PREVIOUS_SHA}" ]] ; then
  _PREVIOUS_DOTFILES="$(cat "${PREVIOUS_SHA}")"
fi

if [[ -n "${_PREVIOUS_DOTFILES:-}" ]] ; then
  CHANGED_FILES="$(git log --pretty='format:' --name-only "${_PREVIOUS_DOTFILES}"..HEAD | sort | uniq)"
fi

files_changed () {
  if [[ -z "${1}" ]] ; then
    _internal_error "Bad usage of files_changed: need argument"
    return 1
  fi

  if [[ -z "${_PREVIOUS_DOTFILES:-}" ]] ; then
    return 0
  fi
  if [[ "${CHANGED_FILES}" =~ $1 ]] ; then
    return 0
  fi
  return 1
}

if files_changed ".gitmodules" ; then
  echo "Detected update to git submodules, updating"
  git submodule update --init --recursive
  echo -e "${BLUE_BG}Done${RESET}"
fi

if files_changed "bootstrap" ; then
  echo "Detected bootstrap changes"
  if _askForConfirmation "Re-run bootstrap?" "Y" ; then
    "${THISDIR}"/bootstrap.sh
  fi
fi

if files_changed ".vimrc" ; then
  # TODO pass vars from autoupdate to only run if .vimrc has changed
  if command -v vim >/dev/null ; then
    _vim=vim
    if command -v nvim > /dev/null ; then
      _vim=nvim
    fi
    echo "Detected change to .vimrc, updating vim plugins"
    ${_vim} +PlugInstall +PlugClean +qall
    unset _vim
    echo -e "${BLUE_BG}Done${RESET}"
  fi
fi

if files_changed ".doom.d/init.el" ; then
  "${HOME}/.emacs.d/bin/doom" sync
fi

echo
echo -e "${BOLD}Installation complete${RESET}"
rm -f "${PREVIOUS_SHA}"
git rev-parse HEAD  > "${PREVIOUS_SHA}"
popd > /dev/null
