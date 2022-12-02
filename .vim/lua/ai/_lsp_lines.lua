local ok, lsp_lines = pcall(require, 'lsp_lines')

-- Disable by default, too annoying to write rust with
local lines_enabled = false

if ok then
  lsp_lines.setup()
  -- Disable virtual_text since it's redundant due to lsp_lines.
  vim.diagnostic.config({
    virtual_text = not lines_enabled,
    virtual_lines = lines_enabled,
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
