command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1|nohl
nnoremap <leader>re :Reverse<cr>
vnoremap <leader>re :Reverse<cr>
