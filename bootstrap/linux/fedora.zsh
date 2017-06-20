_setup_fedora() { (
  sudo dnf install -y perl-open redhat-lsb-core
) }

[[ -f /etc/fedora-release ]] && _setup_fedora
