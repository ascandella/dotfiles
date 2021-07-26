" Don't save buffer-specific keybindings
set viewoptions-=options

" Show open folds in sign column
if has('nvim-0.5')
  set foldcolumn=auto
endif

augroup SaveFolds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END
