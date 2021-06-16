" Don't save buffer-specific keybindings
set viewoptions-=options

" Show open folds in sign column
set foldcolumn=auto

augroup SaveFolds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END
