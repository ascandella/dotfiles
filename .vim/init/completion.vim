" enable deoplete completion
if has('python3')
  autocmd BufEnter * call ncm2#enable_for_buffer()
endif

set completeopt=noinsert,menuone,noselect

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:AutoPairsMapCR=0

inoremap <silent> <Plug>(MyCR) <CR><C-R>=AutoPairsReturn()<CR>

" example
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>(MyCR)" : "\<Plug>(MyCR)")
