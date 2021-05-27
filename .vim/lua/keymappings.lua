local utils = require('utils')

utils.map('n', '<Leader>,', "<Cmd>lua require('telescope-config').project_files()<CR>", {noremap = true, silent = true})
utils.map('n', '<Leader>h',
  "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>gf',
  "<Cmd>lua require('telescope.builtin').git_status()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>a',
  "<Cmd>lua require('telescope-config').livegrep_project()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>fs',
  "<Cmd>lua require('telescope-config').grep_string_hidden()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>S',
  "<Cmd>lua require('spectre').open()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>sw',
  "viw:lua require('spectre').open_visual()<CR>",
  {noremap = true, silent = true}
)

utils.map('n', '<Leader>sp',
  "viw:lua require('spectre').open_file_search()<CR>",
  {noremap = true, silent = true}
)
