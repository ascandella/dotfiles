local ts = require('nvim-treesitter.configs')
ts.setup({
  ensure_installed = {
    'bash',
    'clojure',
    'css',
    'dockerfile',
    'erlang',
    'go',
    'graphql',
    'hcl',
    'heex',
    'javascript',
    'json',
    'lua',
    'python',
    'ruby',
    'rust',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,
    disable = {
      -- These are all too slow to be usable
      'elixir',
    },
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
})
