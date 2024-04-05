-- latte, frappe, macchiato, mocha
local function init()
  require('catppuccin').setup({
    term_colors = false,
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    styles = {
      keywords = { 'italic' },
      -- variables = { 'italic' },
      booleans = { 'italic' },
      -- properties = { 'italic' },
    },
    dim_inactive = {
      enabled = true, -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.10, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
      cmp = true,
      lsp_trouble = true,
      treesitter = true,
      gitsigns = true,
      illuminate = {
        enable = true,
        lsp = false,
      },
      neogit = true,
      treesitter_context = false, -- use custom theme
      telescope = {
        enabled = true,
        style = 'nvchad',
      },
    },
  })

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
