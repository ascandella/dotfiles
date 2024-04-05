require('treesitter-context').setup({
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 8,
  line_numbers = false,
  separator = nil,
})

vim.api.nvim_command([[
  hi TreesitterContextBottom gui=none guisp=Grey
]])
