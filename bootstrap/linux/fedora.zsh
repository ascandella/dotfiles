_setup_fedora() {
  sudo dnf install -y perl-open redhat-lsb-core the_silver_searcher
}

[[ -f /etc/fedora-release ]] && _setup_fedora
