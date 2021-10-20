local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  disable_filetype = { 'TelescopePrompt', 'frecency', 'vim' },
  check_ts = true,
})

require('nvim-autopairs.completion.cmp').setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
  auto_select = false, -- *don't* automatically select the first item
  insert = true, -- use insert confirm behavior instead of replace
  map_char = { -- modifies the function or method delimiter by filetypes
    all = '(',
    tex = '{',
  },
})

npairs.add_rules({
  Rule('"""', '"""', { 'elixir', 'eelixir' }),
})
