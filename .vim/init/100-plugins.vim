"
" Command-T
"

let g:CommandTMatchWindowAtTop = 1
let g:CommandTMaxHeight = 15
let g:CommandTCancelMap='<C-x>'

"
" Zencoding (mostly unused)
"

let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
let g:user_zen_settings = {
\ 'indentation': '  '
\}

"
" Powerline
"

let g:Powerline_symbols = 'fancy'

"
" Delimitmate
"

let g:delimitMate_autoclose=0

"
" Syntastic
"

let g:syntastic_javascript_jsl_conf="-conf ~/.jsl.conf"

"
" Fugitive
"

if has("autocmd")
    " Delete fugitive buffers on hide
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif
