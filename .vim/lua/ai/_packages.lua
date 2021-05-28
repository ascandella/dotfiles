local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end
vim.cmd [[packadd packer.nvim]]

local packer = require('packer')
local util = require('packer.util')
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }
  -- Fuzzy find everything
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'kyazdani42/nvim-web-devicons'},
    },
    config = function()
      require('telescope-config')
    end
  }

  -- Magit for neovim
  use {
    'TimUntersberger/neogit',
    --'~/src/neogit',
    requires = {
      {'nvim-lua/plenary.nvim'},
    },
    config = function()
      require('ai/_neogit')
    end
  }

  -- Frequency/recency
  use {
    'nvim-telescope/telescope-frecency.nvim',
    requires = {
      {'tami5/sql.nvim'},
    },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('ai/treesitter-config')
    end
  }


  -- New status line
  use {
    'glepnir/galaxyline.nvim',
    requires = {
      'nvim-lua/lsp-status.nvim'
    },
    config = function()
      require('ai/_galaxyline')
    end
  }

  -- Code completion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('ai/completion')
    end
  }

  -- Highlight other usages of a symbol under cursor, using LSP
  use { 'RRethy/vim-illuminate' }

  -- Snippets
  use {
    'hrsh7th/vim-vsnip',
    requires = {
      -- Default snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('ai/_vsnip')
    end
  }

  -- Show type signature when calling functions
  use {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('ai/_lsp_signature')
    end
  }

  -- Emacs-like keyboard shortcut completion helper
  use {
    'folke/which-key.nvim',
    config = function()
      require('ai/_which-key')
    end
  }

  -- Better LSP code actions
  use {
    'RishabhRD/nvim-lsputils',
    requires = {
      'RishabhRD/popfix'
    },
  }

  -- Use lua for keymapping. Will be builtin to neovim once
  -- https://github.com/neovim/neovim/pull/13823
  -- is merge
  use {
    'tjdevries/astronauta.nvim',
    config = function()
      require('keymappings')
    end
  }

  use 'neovim/nvim-lspconfig'

  -- Find and replace
  use 'windwp/nvim-spectre'

  -- Typescript improvements
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
 end)
