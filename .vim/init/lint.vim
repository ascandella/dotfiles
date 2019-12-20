" Disable mypy because it's slow
let g:ale_linters = {
      \ 'rust': ['rls', 'cargo'],
      \ 'python': ['flake8', 'pylint'],
      \ }

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'rust': ['rustfmt'],
      \ 'python': ['black', 'isort'],
      \ }

" Use clippy to lint instead of cargo if available
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

map <Leader>la :ALEFix<CR>
