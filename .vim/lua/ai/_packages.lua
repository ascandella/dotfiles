local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute('packadd packer.nvim')
end
vim.cmd([[packadd packer.nvim]])

local packer = require('packer')
local util = require('packer.util')
packer.init({ package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack') })

local function init_packer(use)
  use({ 'wbthomason/packer.nvim', opt = true })
  -- Fuzzy find everything
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      require('ai/telescope-config')
    end,
  })

  -- Magit for neovim
  use({
    'TimUntersberger/neogit',
    -- '~/src/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'sindrets/diffview.nvim',
        config = function()
          require('ai/_diffview')
        end,
      },
    },
    config = function()
      require('ai/_neogit')
    end,
  })

  -- Frequency/recency
  use({
    'nvim-telescope/telescope-frecency.nvim',
    requires = { { 'tami5/sql.nvim' } },
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      -- Autoclose HTML/TSX tags
      'windwp/nvim-ts-autotag',
      -- rainbow pairs
      'p00f/nvim-ts-rainbow',
    },
    run = ':TSUpdate',
    config = function()
      require('ai/treesitter-config')
    end,
  })

  -- New status line
  use({
    'NTBBloodbath/galaxyline.nvim',
    requires = { 'nvim-lua/lsp-status.nvim' },
    config = function()
      require('galaxyline.themes.eviline')
    end,
  })

  -- Code completion
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-calc',
      { 'tzachar/cmp-tabnine', run = './install.sh', requires = 'hrsh7th/nvim-cmp' },
    },
    config = function()
      require('ai/completion')
    end,
  })

  -- Highlight other usages of a symbol under cursor, using LSP
  use({ 'RRethy/vim-illuminate' })

  -- Snippets
  use({
    'hrsh7th/vim-vsnip',
    requires = {
      -- Default snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('ai/_vsnip')
    end,
    event = 'InsertEnter *',
  })

  -- Emacs-like keyboard shortcut completion helper
  use({
    'folke/which-key.nvim',
    config = function()
      require('ai/_which-key')
    end,
  })

  -- Github integration
  if vim.fn.executable('gh') == 1 then
    use({
      'pwntester/octo.nvim',
      config = function()
        require('ai/_octo')
      end,
    })
  end

  -- Better git commit messages
  use({ 'rhysd/committia.vim' })

  use({
    'williamboman/nvim-lsp-installer',
    requires = {
      'neovim/nvim-lspconfig',
      'simrat39/rust-tools.nvim',
      -- Extensible linters/formatters
      'glepnir/lspsaga.nvim',
      'mattn/efm-langserver',
    },
    config = function()
      require('ai/_lspinstall')
      require('ai/_lspsaga')
      require('ai/lua-ls')
      require('ai/typescript')
      require('ai/elixir-config')
    end,
  })

  -- Find and replace
  use('windwp/nvim-spectre')

  -- Wrapping/delimiters
  use({
    'andymass/vim-matchup',
    setup = [[require('ai/_matchup')]],
    event = 'BufEnter',
  })

  -- Automatically insert endwise pairs
  use({ 'tpope/vim-endwise', setup = [[require('ai/_endwise')]] })

  -- Undo tree
  use({
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[require('ai/_undotree')]],
  })

  -- View registers
  use('tversteeg/registers.nvim')

  -- Floating terminal
  use({
    'voldikss/vim-floaterm',
    cmd = { 'FloatermNew', 'FloatermToggle' },
    config = [[require('ai/_floaterm')]],
  })

  use({
    'windwp/nvim-autopairs',
    requires = { 'hrsh7th/nvim-cmp' },
    config = [[require('ai/_autopairs')]],
  })

  use({
    'ThePrimeagen/harpoon',
    config = [[require('ai/_harpoon')]],
  })

  -- Focused editing
  use({
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup({})
    end,
  })

  -- Dim inactive regions of code, plays well with zen-mode
  use({
    'folke/twilight.nvim',
  })

  use({
    'numToStr/Comment.nvim',
    config = [[require('ai/_comment')]],
  })

  -- Copilot
  use({
    'https://github.com/github/copilot.vim',
    config = [[require('ai/_copilot')]],
  })

  -- UI
  use({
    'rmehri01/onenord.nvim',
    config = function()
      require('ai/theme').init()
    end,
  })
end

--- startup and add configure plugins
packer.startup(init_packer)
