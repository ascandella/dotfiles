local M = {}

M.copy_module_alias = function()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes([[mT?defmodule <cr>w"zyiW`T<c-w>poalias <c-r>z]], true, false, true),
    'n',
    true
  )
end

return M
