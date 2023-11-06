local ok, lsp_lines = pcall(require, 'lsp_lines')

-- Disable by default, too annoying to write rust with
local lines_enabled = false
local diagnostics_disabled = false

if ok then
  lsp_lines.setup()
  -- Disable virtual_text since it's redundant due to lsp_lines.
  vim.diagnostic.config({
    virtual_text = not lines_enabled,
    virtual_lines = lines_enabled,
  })
end

local function update_config()
  local diagnostic_config = {
    virtual_text = not lines_enabled,
  }
  if ok then
    diagnostic_config.virtual_lines = lines_enabled
  end

  if diagnostics_disabled then
    diagnostic_config.virtual_text = false
    diagnostic_config.virtual_lines = false
  end

  vim.diagnostic.config(diagnostic_config)
end

local function toggle_lsp_lines()
  lines_enabled = not lines_enabled
  update_config()
end

local function toggle_diagnostics()
  diagnostics_disabled = not diagnostics_disabled
  vim.notify('Diagnostics ' .. (diagnostics_disabled and 'disabled' or 'enabled'))
  update_config()
end

return {
  toggle_lsp_lines = toggle_lsp_lines,
  toggle_diagnostics = toggle_diagnostics,
}
