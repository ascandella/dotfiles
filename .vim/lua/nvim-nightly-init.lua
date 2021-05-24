-- Use a separate undo directory to support systems with non-bleeding-edge vim
-- as well
vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')


require('ai/completion')
require('ai/git')
require('ai/lua-ls')

-- Telescope setup
require('telescope-config')

-- ELixir setup
require('elixir-config')

-- Typescript
require('ai/typescript')

-- Keymappings

require('keymappings')
