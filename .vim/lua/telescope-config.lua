local M = {}

M.project_files = function()
  -- local opts = require('telescope.themes').get_dropdown({  winblend = 10 })
  local opts = {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

local actions = require('telescope.actions')
local telescope = require('telescope')
telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
      },
    },
  }
}
telescope.load_extension('frecency')

return M
