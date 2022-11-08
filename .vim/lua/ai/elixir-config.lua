vim.api.nvim_command([[
  autocmd BufEnter *.ex :setlocal filetype=elixir
]])

vim.api.nvim_exec(
  [[
  augroup AiElixir
    autocmd!
    autocmd FileType elixir nnoremap <silent><buffer> <leader>em :lua require('ai/elixir-commands').copy_module_alias() <cr>
  augroup END
]],
  false
)
