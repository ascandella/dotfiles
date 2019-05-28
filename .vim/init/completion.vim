" enable deoplete completion
if has('python3')
  autocmd BufEnter * call ncm2#enable_for_buffer()
endif

set completeopt=noinsert,menuone,noselect
set shortmess+=c

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Fix auto-pairs CR
let g:AutoPairsMapCR=0
"inoremap <silent> <Plug>(MyCR) <CR><C-R>=<Plug>(PearTreeExpand)<CR>
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>(PearTreeExpand)" : "\<Plug>(PearTreeExpand)")

let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
