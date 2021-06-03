local nvim_lsp = require('lspconfig')

nvim_lsp.elixirls.setup{
  on_attach = require('ai/lsp-shared').on_attach,
  cmd = {vim.fn.expand("$HOME/src/elixir-ls/language_server.sh")}
}

vim.api.nvim_command([[
  autocmd BufEnter *.ex :setlocal filetype=elixir
]])

vim.api.nvim_exec([[
  augroup AiElixir
    autocmd!
    autocmd FileType elixir nnoremap <silent><buffer> <leader>ee :lua require('ai/elixir-config').run_tests() <cr>
  augroup END
]], false)

local M = {}
local buffer_opened = false

local project_root_finder = nvim_lsp.util.root_pattern('mix.exs', '.git')

M.open_tests = function()
  local buffer_filename = vim.api.nvim_buf_get_name(0)
  local project_root = project_root_finder(buffer_filename)
  vim.api.nvim_command([[FloatermNew --name=elixir --position=bottomright --cwd=]] .. project_root)
  buffer_opened = true
end

M.run_tests = function()
  if not buffer_opened then
    M.open_tests()
  end
  vim.api.nvim_exec([[
    FloatermSend --name=elixir mix test --stale
    FloatermShow --name=elixir
  ]], false)
end

return M
