" Git (Fugitive) bindings

" Remap gitgutter leader-h
nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap <Leader>gs <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk

" Git blame
map <Leader>gb :Gblame<CR>
map <Leader>gc :Gcommit -v -q<CR>I

" Modified files in the current git repo (FZF plugin)
map <Leader>gf :GFiles?<CR>
