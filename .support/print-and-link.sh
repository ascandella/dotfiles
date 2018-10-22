 _printAndLink () {
  local source="$1"
  local dest="$2"
  local user="${3:-}"
  local privs=""
  if [[ -n "${user}" ]] ; then
    privs="sudo -u ${user}"
  fi
  echo -e "Linking ${GRAY_BG}${source}${RESET} -> ${BLUE_BG}${dest}${RESET}"
  local destdir="$(dirname "${dest}")"
  if [[ ! -d "${destdir}" ]]; then
    echo -e "  Creating parent directory ${BLUE_BG}${destdir}${RESET}"
    $privs mkdir -p "${destdir}"
  fi
  $privs ln -s "${source}" "${dest}"
}

# vim: ft=sh
