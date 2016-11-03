" enable deoplete completion
let g:deoplete#enable_at_startup = 1

" go stuffs
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/.cache/deoplete/go/$GOOS_$GOARCH'

" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
