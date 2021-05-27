local utils = require('utils')

utils.map('n', '<Leader>,', "<Cmd>lua require('telescope-config').project_files()<CR>", {noremap = true, silent = true})
utils.map('n', '<Leader>h',
  "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
  {noremap = true, silent = true}
)
