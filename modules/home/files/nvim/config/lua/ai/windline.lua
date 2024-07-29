-- forked from https://github.com/windwp/windline.nvim/blob/f58634d649d5774d438f745fbd96caca16aef2c2/lua/wlsample/evil_line.lua
local windline = require('windline')
local helper = require('windline.helpers')
local b_components = require('windline.components.basic')
local state = _G.WindLine.state

local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

local hl_list = {
  Black = { 'white', 'AidenBlack' },
  White = { 'black', 'white' },
  Inactive = { 'InactiveFg', 'InactiveBg' },
  Active = { 'ActiveFg', 'AidenBlack' },
}
local basic = {}

local breakpoint_width = 90
basic.divider = { b_components.divider, '' }
basic.bg = { ' ', 'StatusLine' }

local colors_mode = {
  Normal = { 'red', 'AidenBlack' },
  Insert = { 'AidenGreen', 'AidenBlack' },
  Visual = { 'yellow', 'AidenBlack' },
  Replace = { 'blue_light', 'AidenBlack' },
  Command = { 'AidenHighlight', 'AidenBlack' },
}

basic.vi_mode = {
  name = 'vi_mode',
  hl_colors = colors_mode,
  text = function()
    return { { '  ', state.mode[2] } }
  end,
}
basic.square_mode = {
  hl_colors = colors_mode,

  text = function()
    return { { '▊', state.mode[2] } }
  end,
}

basic.lsp_diagnos = {
  name = 'diagnostic',
  hl_colors = {
    red = { 'red', 'AidenBlack' },
    yellow = { 'yellow', 'AidenBlack' },
    blue = { 'blue', 'AidenBlack' },
  },
  width = breakpoint_width,
  text = function(bufnr)
    if lsp_comps.check_lsp(bufnr) then
      return {
        { lsp_comps.lsp_error({ format = '  %s', show_zero = true }), 'red' },
        { lsp_comps.lsp_warning({ format = '  %s', show_zero = true }), 'yellow' },
        { lsp_comps.lsp_hint({ format = ' 󰋼 %s', show_zero = true }), 'blue' },
      }
    end
    return ''
  end,
}
basic.file = {
  name = 'file',
  hl_colors = {
    default = hl_list.Black,
    white = { 'white', 'AidenBlack' },
    magenta = { 'AidenHighlight', 'AidenBlack' },
  },
  text = function(_, _, width)
    if width > breakpoint_width then
      return {
        { b_components.cache_file_size(), 'default' },
        { ' ', '' },
        { b_components.cache_file_name('[No Name]', 'unique'), 'magenta' },
        { b_components.line_col_lua, 'white' },
        { b_components.progress_lua, '' },
        { ' ', '' },
        { b_components.file_modified(' '), 'magenta' },
      }
    else
      return {
        { b_components.cache_file_size(), 'default' },
        { ' ', '' },
        { b_components.cache_file_name('[No Name]', 'unique'), 'magenta' },
        { ' ', '' },
        { b_components.file_modified(' '), 'magenta' },
      }
    end
  end,
}
basic.file_right = {
  hl_colors = {
    default = hl_list.Black,
    white = { 'white', 'AidenBlack' },
    magenta = { 'AidenHighlight', 'AidenBlack' },
  },
  text = function(_, _, width)
    if width < breakpoint_width then
      return {
        { b_components.line_col_lua, 'white' },
        { b_components.progress_lua, '' },
      }
    end
  end,
}

local quickfix = {
  filetypes = { 'qf', 'Trouble', 'trouble' },
  active = {
    { '🚦 Quickfix ', { 'white', 'AidenBlack' } },
    { helper.separators.slant_right, { 'black', 'black_light' } },
    {
      function()
        return vim.fn.getqflist({ title = 0 }).title
      end,
      { 'cyan', 'black_light' },
    },
    { ' Total : %L ', { 'cyan', 'black_light' } },
    { helper.separators.slant_right, { 'black_light', 'InactiveBg' } },
    { ' ', { 'InactiveFg', 'InactiveBg' } },
    basic.divider,
    { helper.separators.slant_right, { 'InactiveBg', 'AidenBlack' } },
    { '🧛 ', { 'white', 'AidenBlack' } },
  },

  always_active = true,
  show_last_status = true,
}

local explorer = {
  filetypes = { 'fern', 'NvimTree', 'lir' },
  active = {
    { '  ', { 'black', 'red' } },
    { helper.separators.slant_right, { 'red', 'NormalBg' } },
    { b_components.divider, '' },
    { b_components.file_name(''), { 'white', 'NormalBg' } },
  },
  always_active = true,
  show_last_status = true,
}

local default = {
  filetypes = { 'default' },
  active = {
    basic.square_mode,
    basic.vi_mode,
    basic.file,
    basic.divider,
    basic.lsp_diagnos,
    basic.file_right,
    { git_comps.git_branch(), { 'AidenHighlight', 'AidenBlack' }, breakpoint_width },
    { ' ', hl_list.Black },
    basic.square_mode,
  },
  inactive = {
    { b_components.full_file_name, hl_list.Inactive },
    basic.file_name_inactive,
    basic.divider,
    basic.divider,
    { b_components.line_col, hl_list.Inactive },
    { b_components.progress, hl_list.Inactive },
  },
}

local function setup()
  windline.setup({
    colors_name = function(colors)
      colors.AidenHighlight = '#ad7cc8'
      colors.AidenGreen = '#C4E88D'
      colors.AidenBlack = '#0f0e26'
      return colors
    end,
    statuslines = {
      default,
      quickfix,
      explorer,
    },
  })
end

return {
  setup = setup,
}
