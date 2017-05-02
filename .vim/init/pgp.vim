"
" PGP
"
nnoremap <silent> <leader>de :w !gpg --decrypt; wait<cr>
nnoremap <silent> <leader>ec :w !gpg --encrypt --armor --trust-model direct -o- -r
nnoremap <silent> <leader>ei :w !gpg --import<cr>
