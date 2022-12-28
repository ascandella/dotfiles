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
vim.o.sw = 2

vim.o.foldcolumn = 'auto'

vim.o.relativenumber = true
vim.o.number = true

-- Use the same status bar for all windows (requires nvim 0.8+)
vim.o.laststatus = 3

vim.cmd([[
  augroup SaveFolds
    autocmd!
    au BufWinLeave *.* mkview 1
    au BufWinEnter *.* silent! loadview 1
  augroup END
]])

vim.api.nvim_command([[
  " Disable syntax for large files
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif
]])

vim.cmd([[
  augroup gitcommit-mapping
    autocmd!
    " Enter append on the first line
    autocmd FileType gitcommit execute "normal! 0" | startinsert
    autocmd FileType gitcommit setlocal textwidth=72 fo+=t

    " Same, but for neogit
    autocmd FileType NeogitCommitMessage execute "normal! 0" | startinsert
    autocmd FileType NeogitCommitMessage setlocal textwidth=72 fo+=t
  augroup END
]])
