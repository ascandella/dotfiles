if has('nvim-0.5')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'TimUntersberger/neogit'

  Plug 'neovim/nvim-lspconfig'
  " New code completion
  Plug 'hrsh7th/nvim-compe'

  " Emacs-like keyboard shortcut completion helper
  Plug 'folke/which-key.nvim', { 'branch': 'main' }

  " Show type signature when calling functions
  Plug 'ray-x/lsp_signature.nvim'
endif
