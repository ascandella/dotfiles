local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = {
    'bash',
    'clojure',
    'css',
    'dockerfile',
    'erlang',
    'go',
    'graphql',
    'javascript',
    'json',
    'lua',
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
      "elixir",
    },
  },
  indent = { enable = true },
  autotag = {
    enable = true,
    filetypes = { "html", "typescriptreact", "javascriptreact" },
  },
}
