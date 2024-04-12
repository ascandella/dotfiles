local USER = vim.fn.expand('$USER')

local sumneko_root_path = ''
local sumneko_binary = ''

if vim.fn.has('mac') == 1 then
  sumneko_root_path = '/Users/' .. USER .. '/src/lua-language-server'
  sumneko_binary = '/Users/' .. USER .. '/src/lua-language-server/bin/macOS/lua-language-server'
elseif vim.fn.has('unix') == 1 then
  sumneko_root_path = '/home/' .. USER .. '/src/lua-language-server'
  sumneko_binary = '/home/' .. USER .. '/src/lua-language-server/bin/Linux/lua-language-server'
else
  print('Unsupported system for sumneko')
end

local M = {}

M.settings = {
  Lua = {
    format = {
      enable = true,
    },
    hint = {
      enable = true,
      arrayIndex = 'Disable',
    },
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
      -- Setup your lua path
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = { 'vim' },
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = { [vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true },
      maxPreload = 10000,
      ignoreDir = {
        vim.o.undodir,
      },
    },
  },
}

if vim.fn.isdirectory(sumneko_root_path) ~= 0 then
  require('lspconfig').sumneko_lua.setup({
    on_attach = require('ai/lsp-shared').on_attach,
    capabilities = require('ai/lsp-shared').capabilities(),
    cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    settings = M.settings,
  })
end

return M
