-- Use a separate undo directory to support systems with non-bleeding-edge vim
-- as well
vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')

-- TODO: fold these into lua, prune unused stuff
vim.cmd([[
  runtime! init/*.vim
]])

require('ai/_packages')

require('ai/keymappings')

require('ai/ui')
