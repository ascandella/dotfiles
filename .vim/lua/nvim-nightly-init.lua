vim.api.nvim_command('set undodir=~/.vim/undo-nvim/')
local neogit = require('neogit')

neogit.setup {}

require('keymappings')
