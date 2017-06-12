filetype off

call plug#begin()

" FZF replaces command-t
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Like powerline, but lighter
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
" Theme
Plug 'nanotech/jellybeans.vim'
"# "Format code with one button press" - https://github.com/Chiel92/vim-autoformat
" Say no more
Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdcommenter'

" dired-style file browsing
Plug 'justinmk/vim-dirvish'

" Code completion
if has('python3')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif


" Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'

" Undo tree
Plug 'sjl/gundo.vim'

"
" Language-specific stuff
"

" Go code completion
Plug 'zchee/deoplete-go', { 'do': 'make' }
" Go refactoring
Plug 'godoctor/godoctor.vim'

" Python code completion
Plug 'zchee/deoplete-jedi'

" TOML syntax
Plug 'cespare/vim-toml'

" Caddyfile (webserver) syntax
Plug 'joshglendenning/vim-caddyfile'

" Rust stuff
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

"
" END Language-specific stuff
"

"
" Snippets
"
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

call pathogen#infect()

runtime! init/**.vim

silent! source ~/.vimrc.local
