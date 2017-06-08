if [[ -z "${THISDIR}" ]] ; then
  pushd "$(dirname "${0}")" > /dev/null
  THISDIR="$(pwd -P)"

  popd >/dev/null
fi
