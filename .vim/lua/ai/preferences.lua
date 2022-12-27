vim.g.mapleader = ','
vim.g.maplocalleader = "'"

vim.o.expandtab = true
vim.o.incsearch = true
vim.o.hlsearch = false

-- Highlight current line number
vim.o.cursorline = true

vim.o.mouse = 'a'

vim.o.breakindent = true
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true

vim.o.swapfile = false

vim.o.textwidth = 80

-- Assume bash for shell scripts
vim.g.is_bash = 1

vim.o.undodir = vim.fn.expand('$HOME/.vim/undo-nvim')

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
