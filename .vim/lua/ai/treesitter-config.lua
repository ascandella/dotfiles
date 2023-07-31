local ts = require('nvim-treesitter.configs')

local function ts_disable(_, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

ts.setup({
  ensure_installed = {
    'bash',
    'clojure',
    'css',
    'erlang',
    'go',
    'graphql',
    'hcl',
    'heex',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'nix',
    'python',
    'ruby',
    'rust',
    'svelte',
    'terraform',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<leader><space>',
      node_incremental = '<leader><space>',
      scope_incremental = '<c-s>',
      node_decremental = '<leader>sd',
    },
  },

  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      return lang == 'elixir' or ts_disable(lang, bufnr)
    end,
  },

  indent = {
    enable = true,
    disable = {
      -- until at least this issue is fixed
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      'python',
    },
  },

  autotag = {
    enable = true,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact' },
  },

  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },

  matchup = {
    -- https://github.com/andymass/vim-matchup#tree-sitter-integration
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>sa'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>sA'] = '@parameter.inner',
      },
    },
  },
})
