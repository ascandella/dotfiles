" Git (Fugitive) bindings

" Git blame
map <Leader>gb :Git blame<CR>

" Modified files in the current git repo (FZF plugin)
map <Leader>gf :GFiles?<CR>

" Git-gutter mappings
map <Leader>gn <Plug>(signify-next-hunk)


autocmd User SignifyHunk call s:show_current_hunk()

function! s:show_current_hunk() abort
  let h = sy#util#get_hunk_stats()
  if !empty(h)
    echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
  endif
endfunction

" Remap gitgutter leader-h
nmap <Leader>gp :SignifyHunkDiff<cr>
nmap <Leader>gu :SignifyHunkUndo<cr>

" Navigate into messenger popup on leader-gm
let g:git_messenger_always_into_popup = 1
" Display diff in messenger popup
let g:git_messenger_include_diff = "current"

nmap <Leader>gr <Plug>(git-messenger)

"
" Fugitive
"

if has("autocmd")
    " Delete fugitive buffers on hide
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

augroup gitcommit-mapping
  autocmd!
  " Enter append on the first line
  autocmd FileType gitcommit execute "normal! 0" | startinsert
  autocmd FileType gitcommit setlocal textwidth=72 fo+=t
augroup END

