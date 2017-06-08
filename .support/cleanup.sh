BASETHISDIR="$(basename "${THISDIR}")"

_maybeCleanupSymlink () {
  if [[ -z "${1}" ]] ; then
    _internal_error "Can't clean up symlink without argument"_
    return 0
  fi
  local dest="${1}"
  local realdest
  realdest="$(readlink "${dest}")"
  # Check for relative symlinks
  if [[ "${realdest}" =~ ^"${BASETHISDIR}"/.* ]] ; then
    realdest="${HOME}/${realdest}"
  fi
  # Remove double-slashes for readability
  dest="${dest/\/\///}"
  if [[ "${realdest}" =~ ${THISDIR}.* ]] ; then
    if [[ ! -e "${realdest}" ]] ; then
      echo -e "${BOLD}Removing bad link: ${RED_FG}${dest}${RESET} (pointing to ${BOLD}${realdest}${RESET})"
      unlink "${dest}"
    fi
  fi
}

