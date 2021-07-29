require('lspinstall').setup()

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  -- LuaFormatter off
  return {
    capabilities = capabilities,
    on_attach = require('ai/lsp-shared').on_attach,
  }
  -- LuaFormatter on
end

local function efm_config(config)
  local old_on_attach = config.on_attach
  config.on_attach = function(client, bufnr)
    -- Don't compete with elixirls for formatting, we only use credo for linting
    -- on elixir
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == "elixir" then
      client.resolved_capabilities.document_formatting = false
    else
      client.resolved_capabilities.document_formatting = true
    end

    old_on_attach(client, bufnr)
  end
  config.filetypes = {
    "caddyfile",
    -- .eex templates
    "eelixir",
    "graphql",
    "json",
    "javascript",
    "javascriptreact",
    "lua",
    "typescript",
    "typescriptreact",
    "sh",
    "svelte",
    "yaml",
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
    config = efm_config(config)
  end

  require('lspconfig')[server].setup(config)
end

