ANTIGEN_SOURCE="${DOTFILES}/ext/antigen/antigen.zsh"
if [[ -s "${ANTIGEN_SOURCE}" ]] ; then
  . "${ANTIGEN_SOURCE}"
  antigen bundle Tarrasch/zsh-autoenv
  antigen apply
fi
unset ANTIGEN_SOURCE

