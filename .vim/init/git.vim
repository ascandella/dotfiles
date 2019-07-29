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

" Update GitGutter on save
autocmd BufWritePost * GitGutter

" Navigate into messenger popup on leader-gm
let g:git_messenger_always_into_popup = 1
" Display diff in messenger popup
let g:git_messenger_include_diff = "current"
