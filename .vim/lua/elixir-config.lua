require('lspconfig').elixirls.setup{
  cmd = {vim.fn.expand("$HOME/src/elixir-ls/language_server.sh")}
}
