_install_brew_packages () {
  local pkgs=(git htop tmux ccat ctags the_silver_searcher)
  for pkg in "${pkgs[@]}" ; do
    brew install "${pkg}" || brew upgrade "${pkg}"
  done
}

_install_brew_packages
