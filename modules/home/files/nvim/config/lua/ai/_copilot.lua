-- https://github.com/jose-elias-alvarez/dotfiles/commit/7ab0a3d66915b5d97f01b8bc0815ac50af9a7ed1
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ''

vim.defer_fn(function()
  require('copilot').setup({
    panel = {
      enabled = false,
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-j>',
      },
    },
  })
end, 100)
