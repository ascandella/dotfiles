-- Use a separate undo directory to support systems with non-bleeding-edge vim
-- as well
vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')

require('ai/_packages')

if vim.fn.has('nvim-0.7') == 1 then
  require('ai/keymappings')
end

require('ai/ui')
