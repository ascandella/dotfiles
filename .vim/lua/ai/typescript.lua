local nvim_lsp = require("lspconfig")

_G.lsp_organize_imports = function()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local lsp_shared = require('ai/lsp-shared')

nvim_lsp.tsserver.setup {
  capabilities = require('ai/lsp-shared').capabilities(),
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    vim.api.nvim_exec([[set signcolumn=yes]], true)
    lsp_shared.on_attach(client)
  end,
}
