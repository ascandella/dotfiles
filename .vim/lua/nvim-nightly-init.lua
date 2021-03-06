-- Use a separate undo directory to support systems with non-bleeding-edge vim
-- as well
vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')

require('ai/_packages')

require('ai/ui')
