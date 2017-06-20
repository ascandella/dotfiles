_setup_ubuntu() {
  sudo apt-get install -y silversearcher-ag
}

command -v apt-get >/dev/null 2>&1 && _setup_ubuntu
