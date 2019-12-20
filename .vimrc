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

  "
  " Language-specific stuff
  "

  " Go stuff
  if has('nvim-0.3.2')
    Plug 'fatih/vim-go'
  endif

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

  " Show Git preview for blame on current line
  Plug 'rhysd/git-messenger.vim'

  " Org mode
  Plug 'jceb/vim-orgmode'
  " Dependency of org mode
  Plug 'tpope/vim-speeddating'

  " Code completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}

  if has("python3")
    " Python completion
    Plug 'davidhalter/jedi-vim'
  endif

  " Auto pairs
  Plug 'tmsvg/pear-tree'

  " Better Python indenting
  Plug 'Vimjas/vim-python-pep8-indent'

  " Focused editing
  Plug 'junegunn/goyo.vim'

  " Undo tree
  Plug 'sjl/gundo.vim'

  Plug 'troydm/zoomwintab.vim'

  " View registers before pasting
  Plug 'junegunn/vim-peekaboo'


  if has("python3")
    " Best Python syntax support
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    "
    " Snippets
    "
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
