" Git (Fugitive) bindings

" Git blame
map <Leader>gb :Gblame<CR>
map <Leader>gc :Gcommit -v -q<CR>I

" Modified files in the current git repo (FZF plugin)
map <Leader>gf :GFiles?<CR>

" Git-gutter mappings
map <Leader>gn <Plug>GitGutterNextHunk

" Remap gitgutter leader-h
nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap <Leader>gs <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
