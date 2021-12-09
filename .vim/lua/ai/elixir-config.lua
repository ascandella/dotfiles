local nvim_lsp = require('lspconfig')

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
