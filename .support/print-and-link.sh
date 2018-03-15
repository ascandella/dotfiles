 _printAndLink () {
  local source="$1"
  local dest="$2"
  echo -e "Linking  ${GRAY_BG}${source}${RESET} -> ${BLUE_BG}${dest}${RESET}"
  local destdir="$(dirname "${dest}")"
  if [[ ! -d "${destdir}" ]]; then
    echo -e "  Creating parent directory ${BLUE_BG}${destdir}${RESET}"
    mkdir -p "${destdir}"
  fi
  ln -s "${source}" "${dest}"
}

# vim: ft=sh
