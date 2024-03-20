-- disabled in visual mode
local yank_group = vim.api.nvim_create_augroup('ai/yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({ timeout = 250, on_visual = false })
  end,
})

local window_group = vim.api.nvim_create_augroup('ai/window', { clear = true })
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  group = window_group,
  callback = function()
    vim.cmd('wincmd =')
  end,
})

vim.o.guifont = 'BerkeleyMonoVariable Nerd Font Mono'
-- https://github.com/neovide/neovide/discussions/1270
vim.g.neovide_input_macos_alt_is_meta = true
