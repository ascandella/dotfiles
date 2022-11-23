local ok, lsp_lines = pcall(require, 'lsp_lines')

local lines_enabled = true
if ok then
  lsp_lines.setup()
  -- Disable virtual_text since it's redundant due to lsp_lines.
  vim.diagnostic.config({
    virtual_text = false,
  })
end

local function toggle_lsp_lines()
  lines_enabled = not lines_enabled
  local diagnostic_config = {
    virtual_text = not lines_enabled,
  }
  if ok then
    diagnostic_config.virtual_lines = lines_enabled
  end

  vim.diagnostic.config(diagnostic_config)
end

return {
  toggle_lsp_lines = toggle_lsp_lines,
}
