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

vim.o.scrolloff = 10

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

vim.cmd([[
  function! NetrwMapping()
    nmap <buffer> h -^
  endfunction

  augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
  augroup END
]])

vim.o.sw = 2

vim.o.foldcolumn = 'auto'

-- Relative and current line numbers both on
vim.o.relativenumber = true
vim.o.number = true

-- Separate status bars per window
vim.o.laststatus = 2

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
    autocmd FileType gitcommit if getline(1) == "" | execute "normal! 0" | startinsert | endif
    autocmd FileType gitcommit setlocal textwidth=72 fo+=t

    " Same, but for neogit
    " autocmd FileType NeogitCommitMessage execute "normal! 0" | startinsert
    autocmd FileType NeogitCommitMessage setlocal textwidth=72 fo+=t
  augroup END
]])

vim.filetype.add({
  filename = {
    ['justfile'] = 'make',
  },
})
