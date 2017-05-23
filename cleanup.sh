#!/bin/bash

pushd "$(dirname "${0}")" > /dev/null
THISDIR="$(pwd -P)"

for file in "${HOME}"/.* ; do
  if [[ -h "${file}" && ! "$(readlink "${file}")" =~ ${THISDIR}.* ]] ; then
    if [[ -e "${THISDIR}/$(basename "${file}")" ]] ; then
      [[ -n "${V}" ]] && echo "Link exists:${file}"
    else
      echo "Unlinking ${file}"
      unlink "${file}"
    fi
  fi
done
