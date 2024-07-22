-- From:
-- https://github.com/elianiva/dotfiles/blob/master/nvim/lua/plugins/_which-key.lua
local wk = require('which-key')

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  icons = {
    breadcrumb = '»',
    separator = '➜ ',
    group = '+',
  },
  win = {
    -- border = { "", "▔", "", "", "", "", "", "" }, -- none, single, double, shadow
    border = 'none',
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 8,                    -- spacing between columns
  },
  show_help = true,                 -- show help message on the command line when the popup is visible
})
