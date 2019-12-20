let g:autocd#autocmd_enable = 1

let g:autocd#markers= {
      \ '*.py': ['requirements.txt', 'setup.py'],
      \ '*.rs': ['Cargo.toml'],
      \ $HOME.'*/src/*': ['.git'],
      \ '*/aiden/.dotfiles/*': ['.git'],
      \ }
