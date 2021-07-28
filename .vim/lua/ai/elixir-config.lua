local nvim_lsp = require('lspconfig')

-- LuaFormatter off
nvim_lsp.elixirls.setup({
  on_attach = function(client, bufnr)
    -- Disable formatting for eelixir, let efm do that
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == "eelixir" then
      client.resolved_capabilities.document_formatting = false
    else
      client.resolved_capabilities.document_formatting = true
    end
    require('ai/lsp-shared').on_attach(client, bufnr)
  end,
  capabilities = require('ai/lsp-shared').capabilities(),
  cmd = { vim.fn.expand("$HOME/src/elixir-ls/language_server.sh") },
})

vim.api.nvim_command([[
  autocmd BufEnter *.ex :setlocal filetype=elixir
]])

vim.api.nvim_exec([[
  augroup AiElixir
    autocmd!
    autocmd FileType elixir nnoremap <silent><buffer> <leader>ee :lua require('ai/elixir-commands').run_tests() <cr>
    autocmd FileType elixir nnoremap <silent><buffer> <leader>eu :lua require('ai/elixir-commands').run_test_at_cursor() <cr>
    autocmd FileType elixir nnoremap <silent><buffer> <leader>eh :lua require('ai/elixir-commands').run_test_at_file() <cr>
  augroup END
]], false)
-- LuaFormatter on
