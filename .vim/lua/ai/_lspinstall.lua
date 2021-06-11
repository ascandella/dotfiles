require('lspinstall').setup()

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = {dynamicRegistration = false}
  return {
    capabilities = capabilities,
    on_attach = require('ai/lsp-shared').on_attach,
  }
end

local function efm_config(config)
  config.filetypes = {
    "elixir", "json", "javascript", "javascriptreact", "lua", "typescript",
    "typescriptreact", "sh",
  }
  return config
end

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  local config = make_config()
  if server == "tailwindcss" then
    config.settings = {
      tailwindCSS = {
        -- NOTE: values for `validate` and `lint.cssConflict` are required by the server
        validate = true,
        lint = {cssConflict = "warning"},
      },
    }
    config.on_new_config = function(new_config)
      new_config.settings.editor = {
        -- optional, for hover code indentation
        tabSize = vim.lsp.util.get_effective_tabstop(),
      }
    end
  end
  if server == "efm" then
    config = efm_config(config)
  end

  require('lspconfig')[server].setup(config)
end

