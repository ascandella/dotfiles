local nvim_lsp = require('lspconfig')

local M = {}

local buffer_opened = false

local project_root_finder = nvim_lsp.util.root_pattern('mix.exs', '.git')

local function open_tests()
  local buffer_filename = vim.api.nvim_buf_get_name(0)
  local project_root = project_root_finder(buffer_filename)
  vim.api.nvim_command([[FloatermNew --name=elixir --position=center --cwd=]] .. project_root)
  buffer_opened = true
end

local function send_command_and_show(command)
  local full_command = [[FloatermSend --name=elixir ]] .. command
  local resp = vim.api.nvim_exec(full_command, true)
  if string.match(resp, ".*No more floaterms.*") then
    open_tests()
    vim.api.nvim_command(full_command)
  end
  vim.api.nvim_command([[FloatermShow --name=elixir]])
end

local function current_line_number()
  local r = vim.api.nvim_win_get_cursor(0)
  return r[1] - 1
end

M.run_tests = function()
  if not buffer_opened then
    open_tests()
  end
  send_command_and_show('mix test --stale')
end

M.run_test_at_cursor = function()
  local buffer_filename = vim.api.nvim_buf_get_name(0)
  local buffer_lineno = current_line_number()

  if not buffer_opened then
    open_tests()
  end

  send_command_and_show('mix test ' .. buffer_filename .. ':' .. buffer_lineno)
end

return M
