local ok, lsp_lines = pcall(require, 'lsp_lines')

if ok then
  lsp_lines.setup()
  -- Disable virtual_text since it's redundant due to lsp_lines.
  vim.diagnostic.config({
    virtual_text = false,
  })
end
