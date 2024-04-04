local previewers = require('telescope.previewers')
local putils = require('telescope.previewers.utils')
local pfiletype = require('plenary.filetype')

local actions = require('telescope.actions')
local telescope = require('telescope')

-- https://github.com/nvim-telescope/telescope.nvim/issues/857#issuecomment-846368690
local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}
  if opts.use_ft_detect == nil then
    local ft = pfiletype.detect(filepath)
    -- Here for example you can say: if ft == "xyz" then this_regex_highlighing else nothing end
    opts.use_ft_detect = false
    putils.regex_highlighter(bufnr, ft)
  end
  previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

local M = {}

telescope.setup({
  defaults = {
    buffer_previewer_maker = new_maker,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    scroll_strategy = 'cycle',
    selection_strategy = 'reset',
    border = {},
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    sorting_strategy = 'ascending',
    selection_caret = '  ',
    entry_prefix = '  ',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      height = 0.80,
      preview_cutoff = 120,
    },
    -- See: https://gitlab.com/dmease/nerd-font-dmenu/-/blob/master/nerdfont.map
    -- for list of nerd font icons
    prompt_prefix = '  ',
    path_display = { 'truncate' },
    mappings = {
      i = {
        ['<C-s-v>'] = actions.select_vertical,
        ['<C-a-v>'] = actions.select_vertical,
        ['<esc>'] = actions.close,
        ['<C-t>'] = false,
        ['<C-u>'] = false,
        -- History in the prompts.
        -- https://github.com/nvim-telescope/telescope.nvim/issues/1208
        ['<C-Down>'] = require('telescope.actions').cycle_history_next,
        ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--hidden', -- search in hidden files
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    frecency = {
      -- disable confirmations
      db_safe_mode = false,
    },
  },
})

telescope.load_extension('frecency')
telescope.load_extension('fzf')
telescope.load_extension('projects')

local lower_ivy = function(opts)
  opts = opts or {}
  return require('telescope.themes').get_ivy(vim.tbl_extend('force', { layout_config = { height = 0.4 } }, opts))
end

M.livegrep_project = function()
  require('telescope.builtin').live_grep(lower_ivy())
end

M.projects = function()
  require('telescope').extensions.projects.projects(lower_ivy({}))
end

M.livegrep_open_files = function()
  require('telescope.builtin').live_grep(lower_ivy({
    grep_open_files = true,
  }))
end

M.grep_string_hidden = function()
  require('telescope.builtin').grep_string({})
end

M.frecency = function()
  require('telescope').extensions.frecency.frecency(lower_ivy({ previewer = false }))
end

M.buffers = function()
  require('telescope.builtin').buffers(lower_ivy())
end

M.git_branches = function()
  require('telescope.builtin').git_branches(lower_ivy())
end

M.oldfiles = function()
  require('telescope.builtin').oldfiles(lower_ivy())
end

M.lsp_references = function()
  require('telescope.builtin').lsp_references(lower_ivy())
end

M.workspace_symbols = function()
  require('telescope.builtin').lsp_workspace_symbols()
end

M.project_files = function()
  local opts = {}

  local current_directory = vim.api.nvim_buf_get_name(0)
  if current_directory == '' then
    current_directory = vim.fn.getcwd()
  end
  local excludes = {
    ':!:*.age',
  }
  local git_command = { 'git', 'ls-files', '--exclude-standard', '--cached', '.' }

  if string.find(current_directory, '/vitally') then
    vim.table.insert(excludes, ':!:packages/client')
  end

  for _, exclude in ipairs(excludes) do
    table.insert(git_command, exclude)
  end

  opts.git_command = git_command

  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

return M
