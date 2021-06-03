-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local M = {}
M.on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspOrganize lua lsp_organize_imports()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  buf_map(bufnr, "n", "<C-c><C-j>", ":LspDef<CR>", {silent = true})
  buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
  buf_map(bufnr, "n", "gr", ":LspRename<CR>", {silent = true})
  buf_map(bufnr, "n", "gR", ":Telescope lsp_references<CR>", {silent = true})
  buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
  buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
  buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
  buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>", {silent = true})
  buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>", {silent = true})
  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
  buf_map(bufnr, "n", "<Leader>d", ":LspDiagLine<CR>", {silent = true})
  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})

  -- Illuminate visual display. Visual or Cursorline are good fits
  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead Visual ]]

  -- Illuminate mappings
  buf_map(
    bufnr,
    'n',
    '<a-n>',
    '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
    {noremap=true}
  )
  buf_map(
    bufnr,
    'n',
    '<a-p>',
    '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
    {noremap=true}
  )

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
     augroup LspAutocommands
         autocmd! * <buffer>
         autocmd BufWritePost <buffer> LspFormatting
     augroup END
     ]], true)
  end

  require('lsp_signature').on_attach()
  require('illuminate').on_attach(client)


  if client.server_capabilities.colorProvider then
    require("ai/lsp-documentcolors").buf_attach(bufnr, { single_column = true })
  end
end


M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  return capabilities
end


return M
