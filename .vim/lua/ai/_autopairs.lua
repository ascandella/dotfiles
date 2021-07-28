local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  disable_filetype = { 'TelescopePrompt', 'frecency', 'vim' },
  check_ts = true,
})

npairs.add_rules({
  Rule('"""', '"""', { 'elixir', 'eelixir' }),
})
