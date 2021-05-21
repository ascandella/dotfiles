-- Use a separate undo directory to support systems with non-bleeding-edge vim
-- as well
vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')

-- Neogit setup
local neogit = require('neogit')
neogit.setup {}

-- Telescope setup
require('telescope-config')

-- Keymappings

require('keymappings')
