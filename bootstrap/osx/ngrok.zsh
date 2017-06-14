_install_ngrok () {
  if ! command -v ngrok >/dev/null ; then
    echo "Installing ngrok"
    _tmp_work="$(mktemp -d)"
    pushd "${_tmp_work}"

    _zipfile="ngrok-stable-darwin-amd64.zip"
    wget https://bin.equinox.io/c/4VmDzA7iaHb/"${_zipfile}"
    unzip "${_zipfile}"
    unset _zipfile

    _ngrok_dest="${HOME}/bin"
    echo "Installing ngrok to ${_ngrok_dest}"
    mv ./ngrok "${_ngrok_dest}"

    popd
    rm -rf "${_tmp_work}"

    echo "Done"
  fi
  unset -f _install_ngrok
}

_install_ngrok
