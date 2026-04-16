-- nvim-treesitter `main` branch setup.
--
-- Highlighting, folding, and indent are enabled per-filetype via the FileType
-- autocommand below (the equivalent of ftplugin snippets recommended by the
-- plugin's new README).

local nvim_ts = require('nvim-treesitter')

local install_dir = vim.fn.stdpath('data') .. '/site'
nvim_ts.setup({ install_dir = install_dir })

-- Parsers to ensure are installed. `install` runs asynchronously and is a
-- no-op when a parser is already present.
local parsers = {
  'bash',
  'clojure',
  'css',
  'erlang',
  'go',
  'graphql',
  'hcl',
  'heex',
  'html',
  'java',
  'javascript',
  'json',
  'kotlin',
  'lua',
  'markdown',
  'markdown_inline',
  'nix',
  'python',
  'ruby',
  'rust',
  'svelte',
  'terraform',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}
nvim_ts.install(parsers)

-- Filetypes that should get treesitter features. Keyed as a set for quick
-- lookup; the value is a table of per-filetype overrides.
local ts_filetypes = {
  bash = {},
  clojure = {},
  css = {},
  erlang = {},
  go = {},
  graphql = {},
  hcl = {},
  heex = {},
  html = {},
  java = {},
  javascript = {},
  javascriptreact = {},
  json = {},
  kotlin = {},
  lua = {},
  markdown = {},
  nix = {},
  -- elixir highlighting was intentionally disabled in the old config; keep
  -- it off until upstream improves.
  -- elixir = {},
  python = { indent = false }, -- until nvim-treesitter/nvim-treesitter#1136
  ruby = {},
  rust = {},
  svelte = {},
  terraform = {},
  toml = {},
  tsx = {},
  typescript = {},
  typescriptreact = {},
  vim = {},
  yaml = {},
}

local function ts_too_large(bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(ts_filetypes),
  callback = function(args)
    local bufnr = args.buf
    local ft = args.match
    local opts = ts_filetypes[ft] or {}

    if ts_too_large(bufnr) then
      return
    end

    -- Highlighting (provided by Neovim)
    pcall(vim.treesitter.start, bufnr)

    -- Folding (provided by Neovim)
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'

    -- Indent (experimental, provided by nvim-treesitter)
    if opts.indent ~= false then
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- ── nvim-treesitter-textobjects (main-branch API) ─────────────────────────
local ok_to, textobjects = pcall(require, 'nvim-treesitter-textobjects')
if ok_to then
  textobjects.setup({
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require('nvim-treesitter-textobjects.select')
  local move = require('nvim-treesitter-textobjects.move')
  local swap = require('nvim-treesitter-textobjects.swap')

  local map = function(modes, lhs, rhs, desc)
    vim.keymap.set(modes, lhs, rhs, { desc = desc, silent = true })
  end

  -- select
  map({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, 'ts: a parameter')
  map({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, 'ts: inner parameter')
  map({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, 'ts: a function')
  map({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, 'ts: inner function')
  map({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, 'ts: a class')
  map({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, 'ts: inner class')

  -- move
  map({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, 'ts: next function start')
  map({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, 'ts: next class start')
  map({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end, 'ts: next function end')
  map({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end, 'ts: next class end')
  map({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, 'ts: prev function start')
  map({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, 'ts: prev class start')
  map({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, 'ts: prev function end')
  map({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end, 'ts: prev class end')

  -- swap
  map('n', '<leader>sa', function() swap.swap_next('@parameter.inner') end, 'ts: swap next parameter')
  map('n', '<leader>sA', function() swap.swap_previous('@parameter.inner') end, 'ts: swap previous parameter')
end

-- ── nvim-ts-autotag (no longer configured through nvim-treesitter.configs) ─
local ok_at, autotag = pcall(require, 'nvim-ts-autotag')
if ok_at then
  autotag.setup({
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  })
end
