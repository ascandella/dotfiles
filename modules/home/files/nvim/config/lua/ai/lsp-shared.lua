-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local M = {}

local lsp_format = require('lsp-format')

M.maybe_lsp_format = function(options)
  if not vim.b.lsp_disable_formatting then
    options = options or { async = true }
    vim.lsp.buf.format(options)
  end
end

M.toggle_lsp_formatting = function()
  lsp_format.toggle({ args = '' })
  vim.b.lsp_disable_formatting = not vim.b.lsp_disable_formatting
  vim.notify('LSP Formatting ' .. (vim.b.lsp_disable_formatting and 'disabled' or 'enabled'))
end

-- From: https://github.com/daliusd/cfg/blob/0e61894c689d736fa8c59ace8f149ecffb187cc4/.vimrc#L319-L332
local function filter(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.filename, '%.d.ts') == nil
end

-- No longer used? Added file_ignore_patterns per https://github.com/typescript-language-server/typescript-language-server/issues/216#issuecomment-1501193510
local function on_list(options)
  -- https://github.com/typescript-language-server/typescript-language-server/issues/216
  local items = options.items
  if #items > 1 then
    items = filter(items, filterReactDTS)
  end

  vim.fn.setqflist({}, ' ', { title = options.title, items = items, context = options.context })
  vim.api.nvim_command('cfirst')
end

M.lsp_definition = function()
  require('ai/telescope-config').lsp_definitions({ on_list = on_list })
end

local augroup_format = vim.api.nvim_create_augroup('custom-lsp-format', { clear = true })

if vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>ti', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
  end, { desc = 'Toggle Inlay Hints' })
end

lsp_format.setup({
  exclude = 'ts_ls',
})

local autocmd_format = function(client)
  lsp_format.on_attach(client)
end

local default_formatter = function(_, client)
  autocmd_format(client)
end

local filetype_attach = setmetatable({
  astro = default_formatter,
  go = default_formatter,
  nix = default_formatter,

  lua = function(_, client)
    vim.api.nvim_exec([[set signcolumn=yes]], true)
    autocmd_format(client)
  end,

  terraform = default_formatter,

  elixir = default_formatter,

  rust = function(_, client)
    vim.api.nvim_exec([[set signcolumn=yes]], true)

    autocmd_format(client)
  end,

  typescript = function(_, client)
    vim.api.nvim_exec([[set signcolumn=yes]], true)
    autocmd_format(client)
  end,

  javascript = default_formatter,

  json = default_formatter,

  typescriptreact = function(bufnr, client)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      'n',
      '<leader>cn',
      "<cmd>lua require('ai/treesitter/classname').add_or_insert_class_attribute()<cr>",
      {
        noremap = true,
        silent = true,
      }
    )

    autocmd_format(client)
  end,

  python = default_formatter,

  sh = default_formatter,
}, {
  __index = function()
    return function() end
  end,
})

M.on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap

  buf_map(bufnr, 'n', '<C-c><C-j>', ':LspDef<CR>', { silent = true, desc = 'Jump to definition' })
  buf_map(bufnr, 'n', 'gd', ':LspDef<CR>', { silent = true, desc = 'Jump to definition' })
  buf_map(bufnr, 'n', '<Leader>d', ':LspDef<CR>', { silent = true, desc = 'Jump to definition' })
  buf_map(bufnr, 'n', '<Leader>pd', ':Lspsaga peek_definition<CR>', { silent = true, desc = 'Peek definition' })
  buf_map(bufnr, 'n', '<Leader>gr', ':Lspsaga rename<CR>', { silent = true, desc = 'Rename' })
  buf_map(
    bufnr,
    'n',
    'gr',
    ':lua require("ai/telescope-config").lsp_references() <CR>',
    { silent = true, desc = 'LSP References' }
  )
  buf_map(bufnr, 'n', 'gi', ':LspTypeDef<CR>', { silent = true, desc = 'Type definition' })
  buf_map(bufnr, 'n', 'K', ':Lspsaga hover_doc<CR>', { silent = true })
  buf_map(bufnr, 'n', '[a', ':LspDiagPrev<CR>', { silent = true })
  buf_map(bufnr, 'n', ']a', ':LspDiagNext<CR>', { silent = true })
  buf_map(bufnr, 'n', 'ga', ':Lspsaga code_action<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ld', ':Lspsaga show_line_diagnostics<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ft', ':Telescope lsp_document_symbols<CR>', { silent = true })
  buf_map(bufnr, 'i', '<C-k>', '<cmd> LspSignatureHelp<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>tf', ':LspToggleFormatting<CR>', { silent = true })

  -- Disabled because this stopped working in neovim 0.5.1
  if client.server_capabilities.colorProvider then
    require('ai/lsp-documentcolors').buf_attach(bufnr, { single_column = true })
  end

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  -- Attach any filetype specific options to the client
  filetype_attach[filetype](bufnr, client)
end

local cmp_nvim_lsp = require('cmp_nvim_lsp')

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }
  return cmp_nvim_lsp.default_capabilities(capabilities)
end

-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local format_async = function(err, result, ctx)
  if err ~= nil or result == nil then
    return
  end
  if not vim.api.nvim_buf_get_option(ctx.bufnr, 'modified') then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, ctx.bufnr, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding)
    vim.fn.winrestview(view)
    if ctx.bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command('noautocmd :update')
    end
  end
end

vim.lsp.handlers['textDocument/formatting'] = format_async
vim.lsp.handlers['window/showMessage'] = require('ai.lsp.show_message')

vim.cmd('command! LspDef lua require("ai/lsp-shared").lsp_definition()')
vim.cmd("command! LspFormatting lua require('ai/lsp-shared').maybe_lsp_format()")
vim.cmd("command! LspToggleFormatting lua require('ai/lsp-shared').toggle_lsp_formatting()")
vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
vim.cmd('command! LspOrganize lua lsp_organize_imports()')
vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
vim.cmd('command! LspDiagPrev lua vim.diagnostic.goto_prev()')
vim.cmd('command! LspDiagNext lua vim.diagnostic.goto_next()')
vim.cmd('command! LspDiagLine lua vim.diagnostic.open_float()')
vim.cmd('command! LspSignatureHelp lua vim.lsp.buf.signature_help()')

return M
