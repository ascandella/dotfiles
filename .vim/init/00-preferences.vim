"
" Sanity
"

syntax on
filetype plugin indent on

set nocompatible
set nobackup
set noswapfile
set pastetoggle=<F3>
set laststatus=2

"
" Whitespace
"

set expandtab
set softtabstop=2
set sw=2
set cindent
set smartindent
set autoindent

" Turn on line numbering first
" set number
" Then relative numbering
" set relativenumber

set ruler
" Hide tool bar for mvim / gvim
set go=a
set go-=Trm

" Buffer remains hidden on deletion
set hidden

set viminfo='20,\"500

set history=50

set bs=indent,eol,start

set ignorecase

set incsearch
set nohlsearch

set textwidth=80
autocmd FileType gitcommit setlocal textwidth=72 fo+=t

" Ignore files
set wildignore+=*.pyc,*.o,*.obj,.git,app/assets/images
set wildignore+=public/packages,public/assets,vendor/rails
set wildignore+=*.jar,*.zip,*.md5,*.map,*.png,*.jpg,*.svg,*.min.js
set wildignore+=*.eot,*.ttf,*.woff,*.pid
set wildignore+=public/images,vendor,log,tmp,node_modules
set wildignore+=bower_components,assets/build,env
set wildignore+=bower_components,assets/build,Godeps,env

set tags=.git/tags,.tags

set scrolloff=3

set listchars=tab:>-,trail:_,eol:$

"
" Mouse
"

" Strangely enough, mouse works fine in xterm2 without this line. In tmux,
" however, this line is necessary.
if !has('nvim')
  set ttymouse=xterm2
endif
" Enable mouse in all modes (resize splits, etc.)
set mouse=a

set splitbelow
set splitright

" Smarter case-sensitivity for searches
set smartcase

" set this before all files load so they can reference it
let mapleader = ","
let maplocalleader = "'"
