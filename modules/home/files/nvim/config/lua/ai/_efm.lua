local lspconfig = require('lspconfig')
local make_config = require('ai/_lspinstall').make_config

local eslint = require('efmls-configs.linters.eslint_d')
local prettier = require('efmls-configs.formatters.prettier_d')
local stylua = require('efmls-configs.formatters.stylua')
local luacheck = require('efmls-configs.linters.luacheck')
local jsonlint = require('efmls-configs.linters.jsonlint')
local shellcheck = require('efmls-configs.linters.shellcheck')
local shfmt = require('efmls-configs.formatters.shfmt')
local ruff = require('efmls-configs.linters.ruff')
local ruff_fmt = require('efmls-configs.formatters.ruff')

local efm_languages = {
  astro = { prettier },
  graphql = { prettier },
  typescript = { eslint, prettier },
  javascript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  lua = { stylua, luacheck },
  json = { prettier, jsonlint },
  json5 = { prettier },
  sh = { shellcheck, shfmt },
  python = { ruff, ruff_fmt },
}

local function efm_config(config)
  config.filetypes = vim.tbl_keys(efm_languages)
  config.settings = {
    rootMarkers = { 'mix.exs', 'package.json', 'go.mod', '.git/' },
    languages = efm_languages,
    -- For debugging
    -- ['logFile'] = '/tmp/efm.log',
    -- ['logLevel'] = 1,
  }
  return config
end

lspconfig.efm.setup(efm_config(make_config()))
