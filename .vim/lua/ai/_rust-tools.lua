local lsp_installer_servers = require('nvim-lsp-installer.servers')

local server_available = lsp_installer_servers.get_server('rust_analyzer')
if server_available then
  -- NOTE: This isn't actually called, instead we set this up in
  -- `_lspinstall.lua`
  require('rust-tools').setup({})
end
