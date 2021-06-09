local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = {
    'bash',
    'clojure',
    'css',
    'dockerfile',
    'erlang',
    'elixir',
    'go',
    'graphql',
    'javascript',
    'json',
    'lua',
    'ruby',
    'rust',
    'toml',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
    filetypes = { "html", "typescriptreact", "javascriptreact" }
  }
}
