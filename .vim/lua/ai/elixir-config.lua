require('lspconfig').elixirls.setup{
  on_attach = require('ai/lsp-shared').on_attach,
  cmd = {vim.fn.expand("$HOME/src/elixir-ls/language_server.sh")}
}

vim.api.nvim_command([[
  autocmd BufEnter *.ex :setlocal filetype=elixir
]])
