" rustfmt on save
let g:rustfmt_autosave = 1
" enable this until rustfmt-nightly is stable/usable on os x
let g:rustfmt_options = '--force'

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
