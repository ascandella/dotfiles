filetype off

call plug#begin()

let b:enable_nightly = has('nvim-0.5')

" FZF replaces command-t
Plug 'junegunn/fzf.vim'
set rtp+=~/.fzf

" Go refactoring
Plug 'godoctor/godoctor.vim'

" Surround. Nuff Sed.
Plug 'tpope/vim-surround'

" Caddyfile (webserver) syntax
Plug 'joshglendenning/vim-caddyfile'

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

if !b:enable_nightly
  " Use built-in LSP instead of ALE/coc in nightly vim
  " Asynchronous linting
  Plug 'w0rp/ale'
  " Code completion
  if executable("node")
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
    Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
  endif

  if has("python3")
    " Python completion
    Plug 'davidhalter/jedi-vim'
    " Best Python syntax support
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  endif

  " TOML syntax
  Plug 'cespare/vim-toml'

  " Language-specific stuff; superceded by tree-sitter in nightly
  " Rust stuff
  Plug 'rust-lang/rust.vim'

  " Go stuff
  if has('nvim-0.3.2')
    Plug 'fatih/vim-go'
  endif

  " Updated Python syntax
  Plug 'vim-python/python-syntax'

  " rubby :(
  Plug 'vim-ruby/vim-ruby'

  " Terraform / HCL
  Plug 'hashivim/vim-terraform'

  " Use galaxyline in neovim 0.5+
  " Like powerline, but lighter
  Plug 'itchyny/lightline.vim'

  " Show ALE linting issues in lightline
  Plug 'maximbaz/lightline-ale'

  " File browsing
  Plug 'tpope/vim-vinegar'

  " Undo tree
  Plug 'sjl/gundo.vim'

  " View registers before pasting
  Plug 'junegunn/vim-peekaboo'

  " Auto pairs
  Plug 'tmsvg/pear-tree'


  " Focused editing. Use zen-mode.nvim in neovim 0.5+
  Plug 'junegunn/goyo.vim'
end

" Better Python indenting
Plug 'Vimjas/vim-python-pep8-indent'

" Elixir
Plug 'elixir-editors/vim-elixir'

Plug 'troydm/zoomwintab.vim'

" Automatically set current directory (project) when loading file
Plug 'paroxayte/autocd.vim'

" Better startup screen
Plug 'mhinz/vim-startify'

" Toggle quickfix and location list with leader
Plug 'Valloric/ListToggle'

" Theme
Plug 'joshdick/onedark.vim'

"# "Format code with one button press" - https://github.com/Chiel92/vim-autoformat

Plug 'scrooloose/nerdcommenter'

Plug 'mhinz/vim-signify'

if has('unix')
  Plug 'Matt-Deacalion/vim-systemd-syntax'
endif

call plug#end()

runtime! init/**.vim

if b:enable_nightly
  lua require('nvim-nightly-init')
endif

silent! source ~/.vimrc.local
