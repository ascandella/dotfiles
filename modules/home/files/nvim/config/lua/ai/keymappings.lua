local telescope_commands = require('ai/telescope-config')

vim.keymap.set('n', '-', '<cmd>Explore<cr>', { silent = true })
vim.keymap.set('n', '<Leader>,', telescope_commands.project_files, { silent = true, desc = 'Project files' })

vim.keymap.set('n', '<Leader>h', telescope_commands.frecency, { silent = true, desc = 'Recent files' })
vim.keymap.set('n', '<Leader>ff', telescope_commands.oldfiles, { silent = true, desc = 'Old files' })
vim.keymap.set('n', '<Leader>fo', telescope_commands.livegrep_open_files, { silent = true, desc = 'Grep open files' })
vim.keymap.set('n', '<Leader>fp', telescope_commands.projects, { silent = true, desc = 'Projects' })

vim.keymap.set('n', '<Leader>n', telescope_commands.buffers, { silent = true })
vim.keymap.set('n', '<Leader>gf', require('telescope.builtin').git_status, { silent = true, desc = 'Git files' })

vim.keymap.set('n', '<Leader>a', telescope_commands.livegrep_project, { silent = true, desc = 'Grep project' })
vim.keymap.set('v', '<Leader>y', '"*y', { silent = true, desc = 'Yank to system clipboard' })

vim.keymap.set(
  'n',
  '<Leader>fs',
  telescope_commands.grep_string_hidden,
  { silent = true, desc = 'Find string under cursor' }
)

vim.keymap.set(
  'n',
  '<Leader>fn',
  telescope_commands.workspace_symbols,
  { silent = true, desc = 'LSP Workspace Symbols' }
)
vim.keymap.set(
  'n',
  '<Leader>fc',
  require('telescope.builtin').current_buffer_fuzzy_find,
  { silent = true, desc = 'Current buffer fuzzy' }
)

vim.keymap.set('n', '<Leader>fh', require('telescope.builtin').help_tags, { silent = true, desc = 'Vim help' })

vim.keymap.set('n', '<Leader>gg', require('neogit').open, { silent = true, desc = 'Neogit' })
vim.keymap.set('n', '<Leader>gc', require('ai/_neogit').open_pr, { silent = true })
vim.keymap.set('n', '<Leader>gb', require('ai/git').git_blame, { silent = true, desc = 'Git blame' })
vim.keymap.set('x', '<Leader>go', ':GBrowse<cr>', { silent = true, desc = 'Browse selection' })

-- Quickfix
vim.keymap.set('n', '<C-j>', '<cmd>cnext<cr>', { silent = true, desc = 'Next quickfix' })
vim.keymap.set('n', '<C-k>', '<cmd>cprev<cr>', { silent = true, desc = 'Prev quickfix' })

-- Undo Tree
vim.keymap.set('n', '<F1>', '<cmd>UndotreeToggle<cr>', { silent = true })
vim.keymap.set('n', '<Leader>u', '<cmd>UndotreeToggle<cr>', { silent = true, desc = 'Toggle undo tree' })

-- Commenting (most done by plugin in ai/_comment.lua)
vim.keymap.set('x', '<Leader>-', 'gcc', { remap = true })
vim.keymap.set('x', '<Leader>_', 'gbc', { remap = true })

-- Go back to normal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Harpoon mappings
vim.keymap.set('n', '<Leader>v', function()
  -- From: https://github.com/beauwilliams/focus.nvim/issues/64#issuecomment-1439991082
  require('harpoon.ui').toggle_quick_menu()
end, { silent = true })
vim.keymap.set('n', '<Leader>m', require('harpoon.mark').add_file, { silent = true, desc = 'Mark harpoon' })

-- Zen Mode
vim.keymap.set('n', '<F2>', '<cmd>ZenMode<cr>', { silent = true, desc = 'Zen mode' })
vim.keymap.set('n', '<Leader>tz', '<cmd>ZenMode<cr>', { silent = true, desc = 'Zen mode' })

vim.keymap.set('n', '<Leader>tn', '<cmd>QToggle<cr>', { desc = 'Quickfix toggle' })
vim.keymap.set('n', '<Leader>tl', '<cmd>LToggle<cr>', { desc = 'Location list toggle' })

vim.keymap.set('x', 'k', ':m -2<cr>gv=gv', { desc = 'Move lines up' })
vim.keymap.set('x', 'j', ":m'>+<cr>gv=gv", { desc = 'Move lines down' })

-- Twilight (dim inactive)
vim.keymap.set('n', '<Leader>tt', '<cmd>Twilight<cr>', { silent = true })

-- Trouble (LSP diagnostics)
vim.keymap.set(
  'n',
  '<Leader>th',
  '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { silent = true, desc = 'Toggle Trouble (LSP errors)' }
)

-- Toggle between lines and virtual text diagnostics
vim.keymap.set(
  'n',
  '<Leader>td',
  require('ai/_lsp_lines').toggle_lsp_lines,
  { silent = true, desc = 'Toggle diagnostic style' }
)

-- Toggle diagnostics showing at all
vim.keymap.set(
  'n',
  '<Leader>tm',
  require('ai/_lsp_lines').toggle_diagnostics,
  { silent = true, desc = 'Toggle diagnostic enabled' }
)

-- Write
vim.keymap.set('n', '<Leader>w', '<cmd>w<cr>', { silent = true })

-- Dvorak motions
vim.keymap.set('n', 't', 'j', { silent = true })
vim.keymap.set('n', 'n', 'k', { silent = true })
vim.keymap.set('n', 's', 'l', { silent = true })
-- Search
vim.keymap.set('n', 'l', 'nzzzv', { silent = true })
vim.keymap.set('n', 'L', 'Nzzzv', { silent = true })

-- Window movements
--
-- Previous
vim.keymap.set('n', '<C-e>', '<C-w><C-p>', { silent = true })
vim.keymap.set('n', '<A-e>', '<C-w><C-p>', { silent = true })

vim.keymap.set('n', '<A-right>', '<C-w>l', { silent = true })
vim.keymap.set('n', '<A-left>', '<C-w>h', { silent = true })
-- End window movements

vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')

vim.keymap.set('n', '<Leader>b', '<cmd>bd<cr>', { silent = true, desc = 'Delete buffer' })

vim.keymap.set('n', '<Leader>yp', '<cmd>let @" = expand("%")<cr>', { silent = true, desc = 'Yank path' })

vim.keymap.set('n', '<Leader>p', '<cmd>set paste!<cr>', { silent = true, desc = 'Toggle paste mode' })

vim.keymap.set('n', '<Leader>tc', '<cmd>tabclose<cr>', { silent = true, desc = 'Close tab' })
vim.keymap.set(
  'n',
  '<Leader>rn',
  '<cmd>:exec &nu==&rnu? "se rnu!" : "se nu!"<cr>',
  { silent = true, desc = 'Cycle line numbers' }
)

vim.cmd([[command! Cq cq]])
vim.cmd([[command! W w]])

local harpoon_jumpers = { '<A-m>', '<A-w>', '<A-v>', '<A-z>' }
for index, mapping in ipairs(harpoon_jumpers) do
  vim.keymap.set('n', mapping, function()
    require('harpoon.ui').nav_file(index)
  end, { silent = true })
end

local lspinfo_group = vim.api.nvim_create_augroup('ai/lspinfo', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lspinfo',
  group = lspinfo_group,
  callback = function()
    vim.keymap.set('n', 'q', ':b<cr>', { silent = true, buffer = true })
  end,
})

local ts_group = vim.api.nvim_create_augroup('ai/ts', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'javascript' },
  group = ts_group,
  callback = function()
    -- Focus test, it()
    vim.keymap.set('n', '<Leader>fi', 'mf?it(<cr>wi.only<esc>`f', { silent = true, desc = 'Focus test', buffer = true })
    -- Unfocus test
    vim.keymap.set('n', '<Leader>fo', 'mf?it\\.<cr>wdt(`f', { silent = true, desc = 'Unfocus test', buffer = true })
  end,
})

-- "q" to close git blame and restore lspsaga winbar
local gitblame_group = vim.api.nvim_create_augroup('ai/gitblame', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fugitiveblame',
  group = gitblame_group,
  callback = function()
    vim.keymap.set('n', 'q', require('ai/git').git_unblame, { silent = true, buffer = true })
  end,
})

-- After entering a commit from fugitive (blame), just "q" to close
local git_group = vim.api.nvim_create_augroup('ai/git', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'git',
  group = git_group,
  callback = function()
    vim.keymap.set('n', 'q', ':bd<cr>', { silent = true, buffer = true })
  end,
})
