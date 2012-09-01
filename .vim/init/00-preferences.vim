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

" Vim 7.3+ only
set relativenumber

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

" Ignore files
set wildignore+=*.o,*.obj,.git,app/assets/javascripts,public/packages,public/assets,vendor/rails,*.jar,*.zip,*.md5,public/images,public/stylesheets,vendor,log,tmp

set scrolloff=3

set listchars=tab:>-,trail:_,eol:$

"
" Mouse
"

" Strangely enough, mouse works fine in xterm2 without this line. In tmux,
" however, this line is necessary.
set ttymouse=xterm2
" Enable mouse in all modes (resize splits, etc.)
set mouse=a
