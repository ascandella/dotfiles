local cmp_nvim_lsp = require('cmp_nvim_lsp')

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

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = servers,
})

local function make_config(extra_options)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return vim.tbl_deep_extend('force', {
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities),
    on_attach = require('ai/lsp-shared').on_attach,
  }, extra_options or {})
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
  config.root_dir = require('lspconfig').util.root_pattern('mix.exs', 'package.json', '.git')
  return config
end

local function tailwindcss_config(config)
  config.filetypes = {
    'django-html',
    'jinja',
    'tsx',
    'html',
    'eelixir',
    'gohtml',
    'css',
    'sass',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  }
  config.init_options = {
    userLanguages = {
      jinja = 'django-html',
    },
  }
  return config
end

local lspconfig = require('lspconfig')

lspconfig.efm.setup(efm_config(make_config()))

lspconfig.elixirls.setup(make_config({
  -- Override to disable eelixir and heex (use EFM)
  filetypes = { 'elixir' },
}))

lspconfig.sumneko_lua.setup(make_config({
  settings = require('ai/lua-ls').settings,
  on_attach = function(client)
    -- Disable document formatting; allow efm to win
    client.server_capabilities.documentFormattingProvider = false
  end,
}))

lspconfig.tailwindcss.setup(tailwindcss_config(make_config()))

lspconfig.tsserver.setup(make_config({
  -- TODO these inlay hints don't seem to be working? remove this whole block?
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  -- END TODO
  on_attach = function(client)
    -- Disable document formatting; allow efm/prettier to win
    client.server_capabilities.documentFormattingProvider = false
    vim.api.nvim_exec([[set signcolumn=yes]], true)
  end,
}))

lspconfig.terraformls.setup(make_config())
lspconfig.gopls.setup(make_config())
