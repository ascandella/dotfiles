_install_brew_packages () {
  local pkgs=(git htop tmux bat ripgrep)
  for pkg in "${pkgs[@]}" ; do
    brew install "${pkg}" || brew upgrade "${pkg}"
  done
}

_install_brew_packages
