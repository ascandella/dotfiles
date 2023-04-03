-- latte, frappe, macchiato, mocha
local function init()
  vim.g.catppuccin_flavour = 'mocha'
  require('catppuccin').setup()

  vim.api.nvim_command('colorscheme catppuccin')

  vim.api.nvim_command([[
    hi LspInlayHint guifg=#585b70 guibg=#2a2b3c
  ]])

  -- From: https://www.reddit.com/r/neovim/comments/xcsatv/comment/iq32go0/?utm_source=reddit&utm_medium=web2x&context=3
  local colors = require('catppuccin.palettes').get_palette()
  local TelescopeColor = {
    TelescopeMatching = { fg = colors.flamingo },
    TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

    TelescopePromptPrefix = { bg = colors.surface0 },
    TelescopePromptNormal = { bg = colors.surface0 },
    TelescopeResultsNormal = { bg = colors.mantle },
    TelescopePreviewNormal = { bg = colors.mantle },
    TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
    TelescopeResultsTitle = { fg = colors.mantle },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
  }

  for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return {
  init = init,
}
