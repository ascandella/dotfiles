-- disabled in visual mode
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
