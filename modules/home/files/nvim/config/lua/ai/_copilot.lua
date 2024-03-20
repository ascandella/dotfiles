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
      enabled = false,
      auto_trigger = false,
      keymap = {
        accept = '<C-j>',
      },
    },
  })
  require('copilot_cmp').setup({
    -- Remove trailing parens on copilot insertion
    formatters = {
      insert_text = require('copilot_cmp.format').remove_existing,
    },
  })
end, 100)
