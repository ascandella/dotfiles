-- From:
-- https://github.com/elianiva/dotfiles/blob/master/nvim/lua/plugins/_which-key.lua
local wk = require("which-key")

local registrations = {
  b = "Close buffer",
  h = "Telescope Frecency",
  f = {
    name = "+Telescope",
    b    = "Git branches",
    f    = "Files",
    h    = "Help",
    g    = "Live grep",
    l    = "File Browser",
    s    = "Search word under cursor",
  },
  g = {
    name  = "+LSP",
    a     = "Code Action" ,
    d     = "Symbol Definition(s)" ,
    r     = "Symbol Reference(s)" ,
    R     = "Rename Symbol" ,
    t     = "Show Diagnostic List" ,
    ["]"] = "Next Diagnostic",
    ["["] = "Prev Diagnostic" ,
  },
  n = "Telescope buffers",
  a = "Swap With Next Parameter",
  A = "Swap With Prev Parameter",
  w = "Write",
  S = "Search and replace",
  s = {
    s = "Sort paragraph",
    w = "Search and replace word under cursor",
  },
  t = {
    name = "+Toggle",
    n = "Quickfix",
    l = "Location List",
    s = "Toggle trailing whitespace cleanup hook",
  },
  u = "Toggle undo tree",
  y = {
    name = "+Yank",
    p = "Current buffer"
  },
}
registrations[","] = "Search Project"
registrations["."] = "Newline above"
registrations["-"] = "Toggle line comment"
wk.register(registrations, { prefix = "<leader>" })

wk.register({
  gc = "Comments",
  gJ = "Join Multiline",
  gS = "Split Into Multiline",

  -- vim-sandwich
  sa = "Add Surrounding Character",
  sd = "Remove Surrounding Character",
  sr = "Replace Surrounding Character",
})

wk.setup {
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  icons = {
    breadcrumb = "»",
    separator = "➜ ",
    group = "+",
  },
  window = {
    -- border = { "", "▔", "", "", "", "", "", "" }, -- none, single, double, shadow
    border = "none",
    position = "bottom", -- bottom, top
    margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 4, 2, 4, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 8, -- spacing between columns
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = {
    "<silent>",
    "<cmd>",
    "<Cmd>",
    "<CR>",
    "call",
    "lua",
    "^:",
    "^ ",
  }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
}
