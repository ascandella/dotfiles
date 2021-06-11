require('lspinstall').setup()

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
}

local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return {
    capabilities = capabilities,
    on_attach = require('ai/lsp-shared').on_attach,
  }
end

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  local config = make_config()
  if server == "tailwindcss" then
    config.settings = {
      tailwindCSS = {
        -- NOTE: values for `validate` and `lint.cssConflict` are required by the server
        validate = true,
        lint = { cssConflict = "warning" },
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
    config.settings = {
      rootMarkers = { "package.json", "mix.exs", ".git" },
      languages = {
        json = {prettier},
        javascript = {eslint, prettier},
        javascriptreact = {eslint, prettier},
        typescript = {eslint, prettier},
        typescriptreact = {eslint, prettier},
      },
    }
    local old_on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = true
      old_on_attach(client, bufnr)
    end
    config.filetypes = {
      "json",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    }
  end

  require('lspconfig')[server].setup(config)
end

