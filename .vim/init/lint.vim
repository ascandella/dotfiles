let g:ale_linters = {
      \ 'rust': ['rls', 'cargo']
      \ }

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'rust': ['rustfmt'],
      \ 'python': ['black', 'isort'],
      \ }

" Use clippy to lint instead of cargo if available
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

map <Leader>l :ALEFix<CR>
