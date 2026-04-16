require('illuminate').configure({
  under_cursor = false,
  -- nvim-treesitter main-branch dropped the legacy `locals` module that the
  -- treesitter provider relies on, so restrict illuminate to LSP + regex.
  providers = {
    'lsp',
    'regex',
  },
})

vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
