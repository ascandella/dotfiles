" stolen from: https://github.com/peter-edge/dotfiles/blob/master/vimrc#L201
"
" reopen to last position in file
" do not do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim)
" also do not do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
