#!/bin/bash

pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

for file in "${HOME}"/.* ; do
  [[ -h "${file}" ]] || continue
  realfile="$(readlink "${file}")"
  if [[ ! "${realfile}" =~ ${THISDIR}.* ]] ; then
    if [[ -e "${THISDIR}/$(basename "${file}")" ]] ; then
      [[ -n "${V}" ]] && echo "Link exists:${file}"
    elif [[ ! -e "${realfile}" ]] ; then
      echo "Unlinking ${file}"
      unlink "${file}"
    fi
  fi
done
