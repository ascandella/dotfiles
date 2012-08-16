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
set wildignore+=*.o,*.obj,.git,dev-server/**,*.class,public/packages/**,public/assets/**,vendor/rails/**,*.jar,*.zip,*.md5,target/**,mvn-local-repo/**,public/images/**,public/stylesheets/images/**,vendor/**,log

set scrolloff=3

set listchars=tab:>-,trail:_,eol:$
