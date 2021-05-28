if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'

  " Find and replace
  Plug 'windwp/nvim-spectre'

  " Use lua for keymapping. Will be builtin to neovim once
  " https://github.com/neovim/neovim/pull/13823
  " is merge
  Plug 'tjdevries/astronauta.nvim'

  " Better LSP code actions
  Plug 'RishabhRD/nvim-lsputils'
  " Dependency of lsputils
  Plug 'RishabhRD/popfix'

  " Typescript improvements
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
endif
