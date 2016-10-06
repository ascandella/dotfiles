filetype off

call plug#begin()

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'nanotech/jellybeans.vim'
"# "Format code with one button press" - https://github.com/Chiel92/vim-autoformat
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-fugitive'
Plug 'joshglendenning/vim-caddyfile'
Plug 'scrooloose/nerdcommenter'

call plug#end()

call pathogen#infect()

runtime! init/**.vim

silent! source ~/.vimrc.local
