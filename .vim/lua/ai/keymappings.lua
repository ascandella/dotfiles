local telescope_commands = require('ai/telescope-config')

vim.keymap.set('n', '-', '<cmd>Explore<cr>', { silent = true })
vim.keymap.set('n', '<Leader>,', telescope_commands.project_files, { silent = true })

vim.keymap.set('n', '<Leader>h', telescope_commands.frecency, { silent = true })
vim.keymap.set('n', '<Leader>ff', telescope_commands.oldfiles, { silent = true })
vim.keymap.set('n', '<Leader>fo', telescope_commands.livegrep_open_files, { silent = true })

vim.keymap.set('n', '<Leader>n', telescope_commands.buffers, { silent = true })
vim.keymap.set('n', '<Leader>gf', require('telescope.builtin').git_status, { silent = true })

vim.keymap.set('n', '<Leader>a', telescope_commands.livegrep_project, { silent = true })

vim.keymap.set('n', '<Leader>fs', telescope_commands.grep_string_hidden, { silent = true })
vim.keymap.set('n', '<Leader>fb', require('telescope.builtin').current_buffer_fuzzy_find, { silent = true })

vim.keymap.set('n', '<Leader>gg', '<cmd>Neogit<cr>', { silent = true })
vim.keymap.set('n', '<Leader>gc', require('ai/_neogit').open_pr, { silent = true })

-- Undo Tree
vim.keymap.set('n', '<F1>', '<cmd>UndotreeToggle<cr>', { silent = true })
vim.keymap.set('n', '<Leader>u', '<cmd>UndotreeToggle<cr>', { silent = true })

vim.keymap.set('n', '<Leader>ft', '<cmd>FloatermToggle<cr>', { silent = true })
vim.keymap.set('n', '<A-j>', '<cmd>FloatermToggle<cr>', { silent = true })

-- Commenting (most done by plugin in ai/_comment.lua)
vim.keymap.set('x', '<Leader>-', 'gcc', { remap = true })
vim.keymap.set('x', '<Leader>_', 'gbc', { remap = true })

-- Terminal mode mappings
vim.keymap.set('t', '<Leader>ft', '<cmd>FloatermToggle<cr>', { silent = true })
vim.keymap.set('t', '<A-j>', '<cmd>FloatermToggle<cr>', { silent = true })
-- Go back to normal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Harpoon mappings
vim.keymap.set('n', '<A-h>', require('harpoon.ui').toggle_quick_menu, { silent = true })
vim.keymap.set('n', '<Leader>m', require('harpoon.mark').add_file, { silent = true })

-- Zen Mode
vim.keymap.set('n', '<F2>', '<cmd>ZenMode<cr>', { silent = true })
vim.keymap.set('n', '<Leader>tz', '<cmd>ZenMode<cr>', { silent = true })

-- Twilight (dim inactive)
vim.keymap.set('n', '<Leader>tt', '<cmd>Twilight<cr>', { silent = true })

-- Trouble (LSP diagnostics)
vim.keymap.set('n', '<Leader>th', '<cmd>Trouble<cr>', { silent = true })

-- Copilot
-- Couldn't get this to work with vimscript
vim.api.nvim_command([[
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
]])
-- imap({
--   '<C-j>',
--   function()
--     return 'copilot#Accept("<cr>")'
--   end,
--   { expr = true, silent = true, remap = true },
-- })

local harpoon_jumpers = { '<C-h>', '<C-t>', '<C-n>', '<C-s>' }
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
