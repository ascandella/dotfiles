-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local M = {}

M.maybe_lsp_format = function(options)
  if not vim.b.lsp_disable_formatting then
    options = options or { async = true }
    vim.lsp.buf.format(options)
  end
end

M.toggle_lsp_formatting = function()
  vim.b.lsp_disable_formatting = not vim.b.lsp_disable_formatting
  if vim.b.lsp_disable_formatting then
    print('LSP Formatting disabled')
  else
    print('LSP Formatting enabled')
  end
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
  vim.lsp.buf.definition({ on_list = on_list })
end

local augroup_format = vim.api.nvim_create_augroup('custom-lsp-format', { clear = true })

local has_inlayhints, inlayhints = pcall(require, 'lsp-inlayhints')

local lsp_format = require('lsp-format')

lsp_format.setup({
  exclude = 'tsserver',
})

local autocmd_format = function(client)
  lsp_format.on_attach(client)
end

local filetype_attach = setmetatable({
  go = function(_, client)
    autocmd_format(client)
  end,

  lua = function(_, client)
    autocmd_format(client)
  end,

  terraform = function(_, client)
    autocmd_format(client)
  end,

  elixir = function(_, client)
    autocmd_format(client)
  end,

  rust = function(_, client)
    vim.api.nvim_exec([[set signcolumn=yes]], true)

    autocmd_format(client)
  end,

  typescript = function(_, client)
    autocmd_format(client)
  end,

  javascript = function(_, client)
    autocmd_format(client)
  end,

  json = function(_, client)
    autocmd_format(client)
  end,

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
}, {
  __index = function()
    return function() end
  end,
})

-- LuaFormatter off
M.on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap

  buf_map(bufnr, 'n', '<C-c><C-j>', ':LspDef<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>d', ':LspDef<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>pd', ':Lspsaga peek_definition<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>gr', ':Lspsaga rename<CR>', { silent = true })
  buf_map(bufnr, 'n', 'gr', ':lua require("ai/telescope-config").lsp_references() <CR>', { silent = true })
  buf_map(bufnr, 'n', 'gi', ':LspTypeDef<CR>', { silent = true, desc = 'Type definition' })
  buf_map(bufnr, 'n', 'K', ':Lspsaga hover_doc<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>gs', ':LspOrganize<CR>', { silent = true })
  buf_map(bufnr, 'n', '[a', ':LspDiagPrev<CR>', { silent = true })
  buf_map(bufnr, 'n', ']a', ':LspDiagNext<CR>', { silent = true })
  buf_map(bufnr, 'n', 'ga', ':Lspsaga code_action<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ld', ':Lspsaga show_line_diagnostics<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ft', ':Telescope lsp_document_symbols<CR>', { silent = true })
  buf_map(bufnr, 'i', '<C-x><C-x>', '<cmd> LspSignatureHelp<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>tf', ':LspToggleFormatting<CR>', { silent = true })

  if has_inlayhints then
    vim.keymap.set('n', '<Leader>ti', inlayhints.toggle, { silent = true, desc = 'Toggle inlay hints', buffer = bufnr })
  end

  -- Disabled because this stopped working in neovim 0.5.1
  if client.server_capabilities.colorProvider then
    require('ai/lsp-documentcolors').buf_attach(bufnr, { single_column = true })
  end

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  -- Attach any filetype specific options to the client
  filetype_attach[filetype](bufnr, client)
end

-- LuaFormatter on

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

if has_inlayhints then
  inlayhints.setup({})
  vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
  vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspAttach_inlayhints',
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require('lsp-inlayhints').on_attach(client, bufnr)
    end,
  })
end

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
