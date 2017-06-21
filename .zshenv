# this file exists so we can use alias in `:!` commands in vim.
# obviously it will only work for aliases defined in the following file

_sourceIfPresent () {
  if [[ -z "${1}" ]] ; then
    echo "Need argument to _sourceIfPresent"
  elif [[ -f "${1}" ]] ; then
    # shellcheck disable=SC1090
    . "${1}"
  fi
}

for halp in "aliases lemonade" ; do
  _sourceIfPresent "${DOTFILES:-$HOME/.dotfiles}/shell/${halp}"
done

_sourceIfPresent "${HOME}/.zshrc.local"

unset -f _sourceIfPresent
# vim: ft=sh
