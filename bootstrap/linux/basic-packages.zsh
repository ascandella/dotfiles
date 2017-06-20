if command -v apt-get >/dev/null ; then
  export _PKG_INSTALL=(apt-get install --upgrade -y)
elif command -v dnf >/dev/null ; then
  export _PKG_INSTALL=(dnf install -y)
fi

sudo "$_PKG_INSTALL[@]" htop git tmux
