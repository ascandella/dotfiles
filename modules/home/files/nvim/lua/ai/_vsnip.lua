-- use .ts snippets in .tsx
vim.g.vsnip_filetypes = {
  typescriptreact = { 'typescript' },
  javascriptreact = { 'javascript' },
}
vim.g.vsnip_snippet_dir = vim.fn.expand('~/.vim/snips')
