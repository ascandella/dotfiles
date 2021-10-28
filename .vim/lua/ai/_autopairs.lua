local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

npairs.setup({
  disable_filetype = { 'TelescopePrompt', 'frecency', 'vim' },
  check_ts = true,
})

npairs.add_rules({
  Rule('"""', '"""', { 'elixir', 'eelixir' }),
})

npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
