local M = {}

M.init = function()
  require('mason').setup({})
  require('mason-lspconfig').setup({})
end

return M
