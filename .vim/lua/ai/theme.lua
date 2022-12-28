-- latte, frappe, macchiato, mocha
local function init()
  vim.g.catppuccin_flavour = 'mocha'
  require('catppuccin').setup()

  vim.api.nvim_command('colorscheme catppuccin')

  vim.api.nvim_command([[
    hi LspInlayHint guifg=#585b70 guibg=#2a2b3c
  ]])
end

return {
  init = init,
}
