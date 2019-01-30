let g:ale_linters = {
      \ 'rust': ['cargo', 'rustc']
      \ }

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'rust': ['rustfmt'],
      \ 'python': ['black', 'isort'],
      \ }

map <Leader>l :ALEFix<CR>
