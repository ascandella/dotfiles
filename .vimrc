filetype off

call plug#begin()

let minimal = "amnesia"
let hostname = substitute(system('hostname'), '\n', '', '')

" most hosts get all the plugins
if hostname != minimal
  " FZF replaces command-t
  Plug 'junegunn/fzf.vim'
  set rtp+=~/.fzf

  " Asynchronous linting
  Plug 'w0rp/ale'

  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  "
  " Language-specific stuff
  "

  " Go stuff
  Plug 'fatih/vim-go'

  " Go refactoring
  Plug 'godoctor/godoctor.vim'

  " TOML syntax
  Plug 'cespare/vim-toml'

  " Surround. Nuff Sed.
  Plug 'tpope/vim-surround'

  " Caddyfile (webserver) syntax
  Plug 'joshglendenning/vim-caddyfile'

  " Rust stuff
  Plug 'rust-lang/rust.vim'

  " Updated Python syntax
  Plug 'vim-python/python-syntax'

  " rubby :(
  Plug 'vim-ruby/vim-ruby'

  " Terraform / HCL
  Plug 'hashivim/vim-terraform'

  " END Language-specific stuff
  "
  "

  " Say no more
  Plug 'tpope/vim-fugitive'
  " Open fugitive in GitHub
  Plug 'tpope/vim-rhubarb'

  " Org mode
  Plug 'jceb/vim-orgmode'
  " Dependency of org mode
  Plug 'tpope/vim-speeddating'

  " Code completion
  if has("python3")
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'

    " Python completion
    Plug 'davidhalter/jedi-vim'
    Plug 'ncm2/ncm2-jedi'

    Plug 'ncm2/ncm2-ultisnips'

    " Path completion
    Plug 'ncm2/ncm2-path'
    " Buf word completion
    Plug 'ncm2/ncm2-bufword'

    " Go completion
    Plug 'ncm2/ncm2-go'
  endif

  " Auto pairs
  Plug 'jiangmiao/auto-pairs'

  " Better Python indenting
  Plug 'Vimjas/vim-python-pep8-indent'

  " Focused editing
  Plug 'junegunn/goyo.vim'

  " Undo tree
  Plug 'sjl/gundo.vim'

  Plug 'troydm/zoomwintab.vim'

  " View registers before pasting
  Plug 'junegunn/vim-peekaboo'

  "
  " Snippets
  "
  if has("python") || has("python3")
    Plug 'SirVer/ultisnips'
  endif
  Plug 'honza/vim-snippets'

  " File browsing
  Plug 'tpope/vim-vinegar'

  " Automatically set current directory (project) when loading file
  Plug 'paroxayte/autocd.vim'

  " Better startup screen
  Plug 'mhinz/vim-startify'
endif

" Mac-only stuff
if has("mac")
  Plug 'sectioneight/vim-kwm'
endif

" These go to all my machines

" Toggle quickfix and location list with leader
Plug 'Valloric/ListToggle'

" Like powerline, but lighter
Plug 'itchyny/lightline.vim'
" Show ALE linting issues in lightline
Plug 'maximbaz/lightline-ale'
Plug 'majutsushi/tagbar'

" Theme
Plug 'kaicataldo/material.vim'

"# "Format code with one button press" - https://github.com/Chiel92/vim-autoformat

Plug 'scrooloose/nerdcommenter'

Plug 'airblade/vim-gitgutter'

if has('unix')
  Plug 'Matt-Deacalion/vim-systemd-syntax'
endif

call plug#end()

runtime! init/**.vim

silent! source ~/.vimrc.local
