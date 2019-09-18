set completeopt=menu,preview
set shortmess+=c

" Use <TAB> to select the popup menu:
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Disable Jedi (python) auto initialization
let g:jedi#auto_initialization = 0

"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"inoremap <silent> <Plug>(MyCR) <CR><C-R>=<Plug>(PearTreeExpand)<CR>
"imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>(PearTreeExpand)" : "\<Plug>(PearTreeExpand)")

let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
