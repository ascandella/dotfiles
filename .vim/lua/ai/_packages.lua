local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local packages = {
  -- Fuzzy find everything
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('ai/telescope-config')
    end,
  },

  -- Magit for neovim
  {
    'TimUntersberger/neogit',
    commit = '0d6002c6af432343937283fb70791fc76fa7227c',
    -- '~/src/neogit',
    dependencies = {
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
  },

  -- Frequency/recency
  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = { { 'tami5/sql.nvim' } },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      -- Autoclose HTML/TSX tags
      'windwp/nvim-ts-autotag',
      -- rainbow pairs
      'p00f/nvim-ts-rainbow',
    },
    run = ':TSUpdate',
    config = function()
      require('ai/treesitter-config')
    end,
  },

  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('ai/treesitter-context-config')
    end,
  },

  -- New status line
  {
    'windwp/windline.nvim',
    config = function()
      require('ai/windline').setup()
    end,
  },

  -- Code completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'zbirenbaum/copilot-cmp',
      { 'tzachar/cmp-tabnine', build = './install.sh', dependencies = 'hrsh7th/nvim-cmp' },
    },
    config = function()
      require('ai/completion')
    end,
  },

  -- Highlight other usages of a symbol under cursor, using LSP
  {
    'RRethy/vim-illuminate',
    config = function()
      require('ai/_illuminate')
    end,
  },

  -- Snippets
  {
    'hrsh7th/vim-vsnip',
    dependencies = {
      -- Default snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('ai/_vsnip')
    end,
    event = 'InsertEnter *',
  },

  -- Emacs-like keyboard shortcut completion helper
  {
    'folke/which-key.nvim',
    config = function()
      require('ai/_which-key')
    end,
  },

  -- Better git commit messages
  { 'rhysd/committia.vim' },

  -- LSP and associated things
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'simrat39/rust-tools.nvim',
      -- Extensible linters/formatters
      'glepnir/lspsaga.nvim',
      'mattn/efm-langserver',
      'simrat39/inlay-hints.nvim',
      { url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
      'j-hui/fidget.nvim',
    },
    config = function()
      require('ai/_lspinstall')
      require('ai/_lspsaga')
      require('ai/lua-ls')
      require('ai/typescript')
      require('ai/elixir-config')
      require('ai/rust-config')
      require('ai/_lsp_lines')
      require('ai/_fidget')
    end,
  },

  -- Wrapping/delimiters
  {
    'andymass/vim-matchup',
    setup = function()
      require('ai/_matchup')
    end,
    event = 'BufEnter',
  },

  -- Automatically insert endwise pairs
  {
    'tpope/vim-endwise',
    init = function()
      require('ai/_endwise')
    end,
  },

  -- Undo tree
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      require('ai/_undotree')
    end,
  },

  -- Better terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('ai/_toggleterm').init()
    end,
  },

  {
    'windwp/nvim-autopairs',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('ai/_autopairs')
    end,
  },

  -- TOKIOOOOO
  {
    'ThePrimeagen/harpoon',
    config = function()
      require('ai/_harpoon')
    end,
  },

  -- Focused editing
  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup({})
    end,
  },

  -- Dim inactive regions of code, plays well with zen-mode
  { 'folke/twilight.nvim' },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('ai/_comment')
    end,
  },

  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      require('ai/_copilot')
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
  },

  -- UI
  {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require('ai/theme').init()
    end,
  },

  { 'pantharshit00/vim-prisma', ft = 'prisma' },

  {
    'folke/trouble.nvim',
    config = function()
      require('ai/_trouble').init()
    end,
  },

  'nvim-treesitter/playground',

  -- Screenshot tool
  {
    'krivahtoo/silicon.nvim',
    build = './install.sh',
    cmd = 'Silicon',
    config = function()
      require('ai/_silicon')
    end,
  },

  -- Test runner (mostly used for Rust right now
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-go',
      'rouge8/neotest-rust',
      'jfpedroza/neotest-elixir',
    },
    config = function()
      require('ai/_neotest').init()
    end,
  },

  -- Astro syntax
  { 'wuelnerdotexe/vim-astro', ft = 'astro' },

  -- Start screen
  {
    'mhinz/vim-startify',
    config = function()
      require('ai/startify')
    end,
  },

  -- Automatically set current directory (project) when loading file
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('ai/project')
    end,
  },

  -- Surround
  'tpope/vim-surround',

  -- Toggle quickfix list
  'Valloric/ListToggle',

  -- Git gutter signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('ai/gitsigns').setup()
    end,
  },

  'axelf4/vim-strip-trailing-whitespace',

  -- Auto-balance splits
  {
    'beauwilliams/focus.nvim',
    config = function()
      require('ai/focus')
    end,
  },

  -- Highlight TODOs, search them with Telescope, and show them in Trouble
  {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('ai/todo')
    end,
  },

  -- Async formatting
  {
    'lukas-reineke/lsp-format.nvim',
  },

  -- Git blame / browse
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
    },
  },
}

-- Github integration
if vim.fn.executable('gh') == 1 then
  table.insert(packages, {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    config = function()
      require('ai/_octo')
    end,
  })
end

require('lazy').setup(packages, {})
