local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_installer = require('nvim-lsp-installer')

-- Include the servers you want to have installed by default below
local servers = {
  'bashls',
  'efm',
  'elixirls',
  'gopls',
  'terraformls',
  'tailwindcss',
  'tflint',
  'tsserver',
  'pyright',
  'sumneko_lua',
  'yamlls',
  'rust_analyzer',
}

-- Autoinstall servers
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print('Installing ' .. name)
      server:install()
    end
  end
end

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

lsp_installer.on_server_ready(function(server)
  local config = make_config()

  if server.name == 'efm' then
    config = efm_config(config)
  elseif server.name == 'elixirls' then
    -- Override to disable eelixir
    config.filetypes = { 'elixir', 'heex' }
  elseif server.name == 'sumneko_lua' then
    config.settings = require('ai/lua-ls').settings
  elseif server.name == 'tsserver' then
    config.on_attach = function(client)
      -- Disable document formatting; allow efm/prettier to win
      client.resolved_capabilities.document_formatting = false
      vim.api.nvim_exec([[set signcolumn=yes]], true)
    end
  end
  server:setup(config)
end)
