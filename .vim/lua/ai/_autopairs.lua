local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

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

npairs.remove_rule('`')
local backtick_rule = npairs.get_rule('```')
npairs.remove_rule('```')
backtick_rule.filetypes = nil
npairs.add_rules({ backtick_rule })

npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
