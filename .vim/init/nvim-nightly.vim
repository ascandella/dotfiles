if has('nvim-0.5')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " Frequency/recency
  Plug 'nvim-telescope/telescope-frecency.nvim'
  " Dependency for frecency - sqlite
  Plug 'tami5/sql.nvim'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'TimUntersberger/neogit'

  Plug 'neovim/nvim-lspconfig'
  " New code completion
  Plug 'hrsh7th/nvim-compe'

  " Emacs-like keyboard shortcut completion helper
  Plug 'folke/which-key.nvim', { 'branch': 'main' }

  " Show type signature when calling functions
  Plug 'ray-x/lsp_signature.nvim'

  " Find and replace
  Plug 'windwp/nvim-spectre'

  " Icons for telescope and others
  Plug 'kyazdani42/nvim-web-devicons'

  " Use lua for keymapping. Will be builtin to neovim once
  " https://github.com/neovim/neovim/pull/13823
  " is merge
  Plug 'tjdevries/astronauta.nvim'

  " Highlight other usages of a symbol under cursor, using LSP
  Plug 'RRethy/vim-illuminate'

  " New status line
  Plug 'glepnir/galaxyline.nvim'
  " Dependency for my galaxyline theme
  Plug 'nvim-lua/lsp-status.nvim'

  " Better LSP code actions
  Plug 'RishabhRD/nvim-lsputils'
  " Dependency of lsputils
  Plug 'RishabhRD/popfix'
endif
