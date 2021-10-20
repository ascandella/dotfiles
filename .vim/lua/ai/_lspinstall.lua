require('lspinstall').setup()
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  -- LuaFormatter off
  return {
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities),
    on_attach = require('ai/lsp-shared').on_attach,
  }
  -- LuaFormatter on
end

local function efm_config(config)
  config.filetypes = {
    'caddyfile',
    'css',
    -- .eex templates
    'eelixir',
    'graphql',
    -- .heex files, eelixir templates for Phoenix LiveView
    'heex',
    'json',
    'javascript',
    'javascriptreact',
    'lua',
    'python',
    'typescript',
    'typescriptreact',
    'sh',
    'svelte',
    'yaml',
  }
  return config
end

local servers = require('lspinstall').installed_servers()
for _, server in pairs(servers) do
  local config = make_config()

  if server == 'efm' then
    config = efm_config(config)
  elseif server == 'elixir' then
    -- Override to disable eelixir
    config.filetypes = { 'elixir' }
  elseif server == 'lua' then
    config.settings = require('ai/lua-ls').settings
  end

  require('lspconfig')[server].setup(config)
end
