let g:autocd#autocmd_enable = 1

let g:autocd#markers_filetype = {
      \ 'python': ['requirements.txt', 'setup.py'],
      \ 'rust': ['Cargo.toml'],
      \ }

let g:autocd#markers_path = {
      \ 'aiden/src': ['.git'],
      \ 'aiden/.dotfiles': ['.git'],
      \ }
