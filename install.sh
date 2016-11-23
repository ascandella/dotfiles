#!/bin/bash

set -eu
set -o pipefail

# http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
pushd "$(dirname $0)" > /dev/null
THISDIR=$(pwd -P)
echo "THis dir ${THISDIR}"

for file in .* ; do 
  if [[ "${file}"  = ".git"  || \
        "${file}" == "." || \
        "${file}" == ".." || \
        "${file}" == ".gitignore" || \
        "${file}" == ".gitmodules" \
     ]]; then
    continue
  fi

  echo "File: ${file}"

  # TODO handle conflicts
  source="${THISDIR}/${file}" 
  dest="$HOME/${file}"
  echo "Source ${source} Dest: ${dest}"
  if [[ -f "${dest}"  || -h "${dest}" ]]; then
    echo "File exists"
    if [[ $(readlink "${dest}") == "${source}" ]] ; then
      echo "${dest} is already a sylink to ${source}"
      continue
    fi
    echo "File didn't exist"
    echo "${dest} already exists and is not a symlink. Overwrite it? y/N"
    read answer
    answer="${answer:-N}"
    if [[ answer == "y" ]]  ; then
      backup="${dest}.bak"
      echo "Overwriting previous file. Saved to  ${backup}"
      mv "${dest}" "${backup}"
      ln -sf "${source}" "${dest}"
    fi
  else
    ln -s "${source}" "${dest}"
  fi
done

mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/src"

mkdir -p "${HOME}/.config"
ln -s "${HOME}/.vim ${HOME}/.config/nvim"

if which i3 > /dev/null ; then
  ln -s "${HOME}/linux/.i3" "${HOME}/.config/"
fi

for file in "${THISDIR}/bin/*" ; do
  ln -s $file "${HOME}/bin/"
done

# TODO OS-XX specific hooks
popd > /dev/null
