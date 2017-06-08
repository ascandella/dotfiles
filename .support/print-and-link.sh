 _printAndLink () {
  local source="$1"
  local dest="$2"
  echo -e "Linking  ${GRAY_BG}${source}${RESET} -> ${BLUE_BG}${dest}${RESET}"
  ln -s "${source}" "${dest}"
}

# vim: ft=sh
