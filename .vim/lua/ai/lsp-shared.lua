-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local M = {}

M.maybe_lsp_format = function()
  if not vim.b.lsp_disable_formatting then
    vim.lsp.buf.format({ async = true})
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

-- LuaFormatter off
M.on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
  vim.cmd('command! LspDef lua vim.lsp.buf.definition()')
  vim.cmd("command! LspFormatting lua require('ai/lsp-shared').maybe_lsp_format()")
  vim.cmd("command! LspToggleFormatting lua require('ai/lsp-shared').toggle_lsp_formatting()")
  vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
  vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
  vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
  vim.cmd('command! LspOrganize lua lsp_organize_imports()')
  vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
  vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
  vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
  vim.cmd('command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()')
  vim.cmd('command! LspDiagNext lua vim.lsp.diagnostic.goto_next()')
  vim.cmd('command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()')
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
  buf_map(bufnr, 'n', '<Leader>gd', ':Lspsaga peek_definition<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>d', ':Lspsaga show_line_diagnostics<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>ld', ':Telescope lsp_document_symbols<CR>', { silent = true })
  buf_map(bufnr, 'i', '<C-x><C-x>', '<cmd> LspSignatureHelp<CR>', { silent = true })
  buf_map(bufnr, 'n', '<Leader>tf', ':LspToggleFormatting<CR>', { silent = true })

  -- Illuminate visual display. Visual or Cursorline are good fits
  vim.api.nvim_command([[ hi def link LspReferenceText CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceWrite CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceRead Visual ]])

  -- Illuminate mappings
  buf_map(bufnr, 'n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', { noremap = true })
  buf_map(
    bufnr,
    'n',
    '<a-p>',
    '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
    { noremap = true }
  )

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_exec(
      [[
     augroup LspAutocommands
       autocmd! * <buffer>
       autocmd BufWritePost <buffer> LspFormatting
     augroup END
     ]],
      true
    )
  end

  require('illuminate').on_attach(client)

  -- Disabled because this stopped working in neovim 0.5.1
  if client.server_capabilities.colorProvider then
    require('ai/lsp-documentcolors').buf_attach(bufnr, { single_column = true })
  end
end

-- LuaFormatter on

local cmp_nvim_lsp = require('cmp_nvim_lsp')

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }
  return cmp_nvim_lsp.update_capabilities(capabilities)
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
