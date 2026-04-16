-- LSP setup using the Neovim 0.11+ `vim.lsp.config` API.
-- The legacy `require('lspconfig').<server>.setup(...)` framework is
-- deprecated and will be removed in nvim-lspconfig v3.0.0.

local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Include the servers you want to have installed by default below
local servers = {
  'astro',
  'bashls',
  'efm',
  'elixirls',
  'gopls',
  'jdtls',
  'jsonls',
  'terraformls',
  'tailwindcss',
  'tflint',
  'ts_ls',
  'pyright',
  'lua_ls',
  'yamlls',
  'rust_analyzer',
}

local nix_enabled = vim.fn.executable('nix') == 1
if nix_enabled then
  table.insert(servers, 'nil_ls')
end

local on_attach = require('ai/lsp-shared').on_attach

-- Shared capabilities for every server.
local function default_capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.colorProvider = { dynamicRegistration = false }
  return cmp_nvim_lsp.default_capabilities(caps)
end

-- Global defaults applied to every server via `vim.lsp.config('*', ...)`.
vim.lsp.config('*', {
  capabilities = default_capabilities(),
  on_attach = on_attach,
})

-- Compose a per-buffer on_attach that runs the shared handler first and then
-- a server-specific tweak (used by servers that disable document formatting
-- so efm/prettier/stylua can win).
local function with_on_attach(extra)
  return function(client, bufnr)
    on_attach(client, bufnr)
    extra(client, bufnr)
  end
end

-- ── Per-server overrides ─────────────────────────────────────────────────
vim.lsp.config('elixirls', {
  -- Disable eelixir/heex — EFM handles those.
  filetypes = { 'elixir' },
})

vim.lsp.config('lua_ls', {
  settings = require('ai/lua-ls').settings,
  on_attach = with_on_attach(function(client, _bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end),
})

vim.lsp.config('tailwindcss', {
  filetypes = {
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
  },
  init_options = {
    userLanguages = {
      jinja = 'django-html',
    },
  },
})

vim.lsp.config('ts_ls', {
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
  },
  on_attach = with_on_attach(function(client, _bufnr)
    client.server_capabilities.documentFormattingProvider = false
    vim.api.nvim_exec2([[set signcolumn=yes]], { output = true })
  end),
})

vim.lsp.config('gopls', {
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
})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').json.schemas(),
      validate = true,
    },
  },
})

if nix_enabled then
  vim.lsp.config('nixd', {
    settings = {
      nixd = {
        formatting = {
          command = { 'nixfmt' },
        },
      },
    },
  })
end

-- ── Mason installs parsers, mason-lspconfig auto-enables them via
--    vim.lsp.enable() once installed. Configs above apply on attach. ──────
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = servers,
  -- rustaceanvim owns rust_analyzer — exclude it so we don't double-attach.
  automatic_enable = {
    exclude = { 'rust_analyzer' },
  },
})

-- Ensure nixd is enabled too (it's not installed via mason when nix is
-- present — it comes from home-manager).
if nix_enabled then
  vim.lsp.enable('nixd')
end

-- Neovim 0.12 ships a built-in `:lsp` command, and nvim-lspconfig now
-- skips registering `:LspInfo` / `:LspLog` / `:LspStart` / etc. when that
-- built-in exists. Preserve the old muscle memory with thin aliases.
--
-- :LspInfo renders a readable summary of clients attached to the current
-- buffer (plus any other active clients) in a scratch floating window.
-- Use `:LspInfo!` for the full `:checkhealth vim.lsp` view.
vim.api.nvim_create_user_command('LspInfo', function(opts)
  if opts.bang then
    vim.cmd('checkhealth vim.lsp')
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  local attached = vim.lsp.get_clients({ bufnr = bufnr })
  local all = vim.lsp.get_clients()

  local lines = {}
  local hl = {} -- { {line, col_start, col_end, group}, ... }

  local function add(line, group)
    table.insert(lines, line)
    if group then
      table.insert(hl, { #lines - 1, 0, -1, group })
    end
  end

  local function header(line)
    add(line, 'Title')
  end

  local function capability_list(client)
    local caps = client.server_capabilities or {}
    -- Most-relevant features; keep the list compact.
    local feature_map = {
      { 'hover',               caps.hoverProvider },
      { 'definition',          caps.definitionProvider },
      { 'references',          caps.referencesProvider },
      { 'rename',              caps.renameProvider },
      { 'completion',          caps.completionProvider },
      { 'signature',           caps.signatureHelpProvider },
      { 'format',              caps.documentFormattingProvider },
      { 'range_format',        caps.documentRangeFormattingProvider },
      { 'code_action',         caps.codeActionProvider },
      { 'diagnostics',         caps.diagnosticProvider },
      { 'inlay_hint',          caps.inlayHintProvider },
      { 'semantic_tokens',     caps.semanticTokensProvider },
      { 'document_symbol',     caps.documentSymbolProvider },
      { 'workspace_symbol',    caps.workspaceSymbolProvider },
      { 'document_highlight',  caps.documentHighlightProvider },
    }
    local have = {}
    for _, entry in ipairs(feature_map) do
      if entry[2] then
        table.insert(have, entry[1])
      end
    end
    return have
  end

  local function format_cmd(cmd)
    if type(cmd) == 'table' then
      return table.concat(cmd, ' ')
    elseif type(cmd) == 'function' then
      return '<function>'
    end
    return tostring(cmd or '-')
  end

  local function render_client(c, indent)
    indent = indent or '  '
    add(('%s%s  (id=%d)'):format(indent, c.name, c.id), 'Identifier')
    add(('%s  root_dir     %s'):format(indent, c.root_dir or '-'))
    add(('%s  filetypes    %s'):format(indent, table.concat(c.config.filetypes or {}, ', ')))
    add(('%s  cmd          %s'):format(indent, format_cmd(c.config.cmd)))
    local attached_bufs = {}
    for b, _ in pairs(c.attached_buffers or {}) do
      table.insert(attached_bufs, tostring(b))
    end
    table.sort(attached_bufs, function(a, b) return tonumber(a) < tonumber(b) end)
    add(('%s  buffers      %s'):format(indent, #attached_bufs > 0 and table.concat(attached_bufs, ', ') or '-'))
    local caps = capability_list(c)
    add(('%s  capabilities %s'):format(indent, #caps > 0 and table.concat(caps, ', ') or '-'))
    if c.workspace_folders and #c.workspace_folders > 0 then
      local ws = {}
      for _, f in ipairs(c.workspace_folders) do
        table.insert(ws, f.name)
      end
      add(('%s  workspaces   %s'):format(indent, table.concat(ws, ', ')))
    end
  end

  header(('LSP — buffer %d  ft=%s'):format(bufnr, ft ~= '' and ft or '-'))
  add(('  %s'):format(bufname ~= '' and bufname or '[No Name]'))
  add('')

  if #attached == 0 then
    add('No LSP clients attached to this buffer.', 'WarningMsg')
  else
    header(('Attached (%d):'):format(#attached))
    for i, c in ipairs(attached) do
      render_client(c)
      if i < #attached then add('') end
    end
  end

  local attached_ids = {}
  for _, c in ipairs(attached) do
    attached_ids[c.id] = true
  end
  local others = {}
  for _, c in ipairs(all) do
    if not attached_ids[c.id] then
      table.insert(others, c)
    end
  end
  if #others > 0 then
    add('')
    header(('Other active clients (%d):'):format(#others))
    for i, c in ipairs(others) do
      render_client(c)
      if i < #others then add('') end
    end
  end

  add('')
  add('[ :LspInfo!  for :checkhealth vim.lsp  |  :LspLog  for log file ]', 'Comment')

  -- Render in a scratch floating window (like old :LspInfo).
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'lspinfo'

  local ns = vim.api.nvim_create_namespace('LspInfoHl')
  for _, h in ipairs(hl) do
    vim.api.nvim_buf_add_highlight(buf, ns, h[4], h[1], h[2], h[3])
  end

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(math.max(width + 4, 60), vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 6)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' LSP Info ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true

  -- q / <Esc> to close.
  for _, key in ipairs({ 'q', '<Esc>' }) do
    vim.keymap.set('n', key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true })
  end
end, { bang = true, desc = 'Show LSP clients attached to the current buffer (:LspInfo! for full checkhealth)' })
vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = 'Open the LSP log file' })
vim.api.nvim_create_user_command('LspRestart', function(args)
  vim.cmd('lsp restart ' .. (args.args or ''))
end, { nargs = '?', desc = 'Alias for :lsp restart' })
vim.api.nvim_create_user_command('LspStop', function(args)
  vim.cmd('lsp stop ' .. (args.args or ''))
end, { nargs = '?', desc = 'Alias for :lsp stop' })

-- Kept for backwards compatibility with any remaining call sites
-- (e.g. the terraformls shim in modules/home/dotconfig.nix). Builds an
-- options table equivalent to the old `make_config` helper.
local function make_config(extra_options)
  return vim.tbl_deep_extend('force', {
    capabilities = default_capabilities(),
    on_attach = on_attach,
  }, extra_options or {})
end

return {
  make_config = make_config,
}
