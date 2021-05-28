-- disabled in visual mode
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank { timeout = 250, on_visual = false}'
