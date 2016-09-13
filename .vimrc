filetype off

call plug#begin()

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'

call plug#end()

call pathogen#infect()

runtime! init/**.vim

silent! source ~/.vimrc.local
