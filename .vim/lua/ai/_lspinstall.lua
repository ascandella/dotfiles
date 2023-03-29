local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Include the servers you want to have installed by default below
local servers = {
  'astro',
  'bashls',
  'efm',
  'elixirls',
  'gopls',
  'rnix',
  'terraformls',
  'tailwindcss',
  'tflint',
  'tsserver',
  'pyright',
  'lua_ls',
  'yamlls',
  'rust_analyzer',
}

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = servers,
})

local on_attach = require('ai/lsp-shared').on_attach

local function make_config(extra_options)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return vim.tbl_deep_extend('force', {
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities),
    on_attach = on_attach,
  }, extra_options or {})
end

local function efm_config(config)
  config.filetypes = {
    'astro',
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
    'astro',
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

lspconfig.lua_ls.setup(make_config({
  settings = require('ai/lua-ls').settings,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Disable document formatting; allow efm to win
    client.server_capabilities.documentFormattingProvider = false
  end,
}))

lspconfig.tailwindcss.setup(tailwindcss_config(make_config()))

lspconfig.tsserver.setup(make_config({
  settings = {
    typescript = {
      inlayHints = {
        -- 'none' | 'literals' | 'all';
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
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Disable document formatting; allow efm/prettier to win
    client.server_capabilities.documentFormattingProvider = false
    vim.api.nvim_exec([[set signcolumn=yes]], true)
  end,
}))

lspconfig.terraformls.setup(make_config())

lspconfig.gopls.setup(make_config({
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}))

lspconfig.astro.setup(make_config())
lspconfig.rnix.setup(make_config())
