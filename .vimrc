filetype off

call plug#begin()

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'nanotech/jellybeans.vim'

" Completion
" ====================================================================
Plug 'Valloric/YouCompleteMe', { 'do': 'python2 install.py --tern-completer' }
" {{{
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_key_invoke_completion = '<c-j>'
  let g:ycm_complete_in_strings = 1
" }}}

call plug#end()

call pathogen#infect()

runtime! init/**.vim

silent! source ~/.vimrc.local
