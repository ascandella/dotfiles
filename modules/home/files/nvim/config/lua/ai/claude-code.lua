local M = {}

M.setup = function()
  local claude_code = require('claude-code')

  -- Set up the Claude Code client
  claude_code.setup({})
end

return M
