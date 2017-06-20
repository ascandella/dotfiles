# vim: ft=sh
# this file exists so we can use alias in `:!` commands in vim.
# obviously it will only work for aliases defined in the following file
source "${DOTFILES:-$HOME/.dotfiles}/shell/aliases"
source "${DOTFILES:-$HOME/.dotfiles}/shell/lemonade"
