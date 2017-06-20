if command -v apt-get >/dev/null ; then
  export _PKG_INSTALL=(apt-get install --upgrade -y)
elif command -v dnf >/dev/null ; then
  export _PKG_INSTALL=(dnf install -y)
fi

if [[ -n "${_PKG_INSTALL[@]}" ]] ; then
  sudo "$_PKG_INSTALL[@]" htop git tmux zsh
else
  echo "Unsupported linux package manager, currently we support apt and dnf"
fi
