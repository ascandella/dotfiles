local M = {}

M.project_files = function()
  -- local opts = require('telescope.themes').get_dropdown({  winblend = 10 })
  local opts = {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

M.livegrep_project = function()
  require('telescope.builtin').live_grep({
  })
end

M.grep_string_hidden = function()
  require('telescope.builtin').grep_string({
  })
end

local actions = require('telescope.actions')
local telescope = require('telescope')
local previewers = require("telescope.previewers")
telescope.setup{
  defaults = {
    file_previewer     = previewers.vim_buffer_cat.new,
    grep_previewer     = previewers.vim_buffer_vimgrep.new,
    qflist_previewer   = previewers.vim_buffer_qflist.new,
    scroll_strategy    = "cycle",
    selection_strategy = "reset",
    layout_strategy    = "flex",
    borderchars        = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    layout_defaults = {
      horizontal = {
        width_padding  = 0.1,
        height_padding = 0.1,
        preview_width  = 0.6,
      },
      vertical = {
        width_padding  = 0.05,
        height_padding = 1,
        preview_height = 0.5,
      },
    },
    mappings = {
      i = {
        ["<C-s-v>"]  = actions.select_vertical,
        ["<esc>"] = actions.close,
        ["<C-t>"] = false,
        ["<C-u>"] = false,
      },
    },
  }
}
telescope.load_extension('frecency')

local no_preview = function(opts)
  opts = opts or {}
  return require("telescope.themes").get_dropdown(
    vim.tbl_extend("force", {
      borderchars = {
        { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        prompt  = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
      width = 0.6,
      previewer = false,
    }, opts)
  )
end


M.frecency = function()
  require("telescope").extensions.frecency.frecency(no_preview())
end

return M
