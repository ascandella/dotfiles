local nvim_lsp = require('lspconfig')
local servers = require('lspinstall').installed_servers()

if servers['elixirls'] ~= nil then
  nvim_lsp.elixirls.setup({
    -- Override to disable eelixir
    filetypes = { 'elixir', 'heex' },
    on_attach = require('ai/lsp-shared').on_attach,
    capabilities = require('ai/lsp-shared').capabilities(),
    cmd = { vim.fn.expand('$HOME/src/elixir-ls/language_server.sh') },
  })
end

vim.api.nvim_command([[
  autocmd BufEnter *.ex :setlocal filetype=elixir
]])

vim.api.nvim_exec(
  [[
  augroup AiElixir
    autocmd!
    autocmd FileType elixir nnoremap <silent><buffer> <leader>ee :lua require('ai/elixir-commands').run_tests() <cr>
    autocmd FileType elixir nnoremap <silent><buffer> <leader>eu :lua require('ai/elixir-commands').run_test_at_cursor() <cr>
    autocmd FileType elixir nnoremap <silent><buffer> <leader>eh :lua require('ai/elixir-commands').run_test_at_file() <cr>
    autocmd FileType elixir nnoremap <silent><buffer> <leader>em :lua require('ai/elixir-commands').copy_module_alias() <cr>
  augroup END
]],
  false
)
