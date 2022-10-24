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

local function on_list(options)
  vim.fn.setqflist({}, ' ', options)
  vim.api.nvim_command('cfirst')
end

M.lsp_definition = function()
  vim.lsp.buf.definition({ on_list = on_list })
end

local augroup_format = vim.api.nvim_create_augroup('custom-lsp-format', { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup('custom-lsp-codelens', { clear = true })

local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = 0,
    callback = function()
      M.maybe_lsp_format({ async = async, filter = filter })
    end,
  })
end

local filetype_attach = setmetatable({
  go = function()
    autocmd_format(false)
  end,

  css = function()
    autocmd_format(false)
  end,

  lua = function()
    autocmd_format(false)
  end,

  rust = function(bufnr)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      'n',
      '<leader>fs',
      "<cmd>lua require('ai/telescope-config').workspace_symbols()<cr>",
      {
        noremap = true,
        silent = true,
      }
    )

    autocmd_format(false)
  end,

  racket = function()
    autocmd_format(false)
  end,

  typescript = function()
    autocmd_format(false, function(client)
      return client.name ~= 'tsserver'
    end)
  end,
}, {
  __index = function()
    return function() end
  end,
})

-- LuaFormatter off
M.on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
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

  buf_map(bufnr, 'n', '<C-c><C-j>', ':LspDef<CR>', { silent = true })
  buf_map(bufnr, 'n', 'gd', ':Lspsaga peek_definition<CR>', { silent = true })
  buf_map(bufnr, 'n', 'gr', ':Lspsaga rename<CR>', { silent = true })
  buf_map(bufnr, 'n', 'gR', ':lua require("ai/telescope-config").lsp_references() <CR>', { silent = true })
  buf_map(bufnr, 'n', 'gy', ':LspTypeDef<CR>', { silent = true })
  buf_map(bufnr, 'n', 'K', ':Lspsaga hover_doc<CR>', { silent = true })
  buf_map(bufnr, 'n', 'gs', ':LspOrganize<CR>', { silent = true })
  buf_map(bufnr, 'n', '[a', ':LspDiagPrev<CR>', { silent = true })
  buf_map(bufnr, 'n', ']a', ':LspDiagNext<CR>', { silent = true })
  buf_map(bufnr, 'n', 'ga', ':Lspsaga code_action<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>d', ':Lspsaga show_line_diagnostics<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ld', ':Telescope lsp_document_symbols<CR>', { silent = true })
  buf_map(bufnr, 'i', '<C-x><C-x>', '<cmd> LspSignatureHelp<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>tf', ':LspToggleFormatting<CR>', { silent = true })

  -- Illuminate mappings
  buf_map(bufnr, 'n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', { noremap = true })
  buf_map(
    bufnr,
    'n',
    '<a-p>',
    '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
    { noremap = true }
  )

  -- Disabled because this stopped working in neovim 0.5.1
  if client.server_capabilities.colorProvider then
    require('ai/lsp-documentcolors').buf_attach(bufnr, { single_column = true })
  end

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_clear_autocmds({ group = augroup_codelens, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup_codelens,
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
      once = true,
    })
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold' }, {
      group = augroup_codelens,
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
      once = true,
    })
  end

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

return M
