local k = require('astronauta.keymap')
local nnoremap = k.nnoremap
local tnoremap = k.tnoremap
local telescope_commands = require('ai/telescope-config')

nnoremap({ '-', '<cmd>Explore<cr>', { silent = true } })
nnoremap({ '<Leader>,', telescope_commands.project_files, { silent = true } })

nnoremap({ '<Leader>h', telescope_commands.frecency, { silent = true } })
nnoremap({ '<Leader>ff', telescope_commands.oldfiles, { silent = true } })
nnoremap({ '<Leader>fo', telescope_commands.livegrep_open_files, { silent = true } })

nnoremap({ '<Leader>n', telescope_commands.buffers, { silent = true } })
nnoremap({
  '<Leader>gf',
  require('telescope.builtin').git_status,
  { silent = true },
})

nnoremap({ '<Leader>a', telescope_commands.livegrep_project, { silent = true } })

nnoremap({
  '<Leader>fs',
  telescope_commands.grep_string_hidden,
  { silent = true },
})
nnoremap({ '<Leader>fb', telescope_commands.git_branches, { silent = true } })

nnoremap({ '<Leader>S', require('spectre').open, { silent = true } })

nnoremap({ '<Leader>sw', require('spectre').open_visual, { silent = true } })

nnoremap({ '<Leader>sp', require('spectre').open_file_search, { silent = true } })

nnoremap({ '<Leader>gg', '<cmd>Neogit<cr>', { silent = true } })
nnoremap({ '<Leader>gc', require('ai/_neogit').open_pr, { silent = true } })

-- Undo Tree
nnoremap({ '<F1>', '<cmd>UndotreeToggle<cr>', { silent = true } })
nnoremap({ '<Leader>u', '<cmd>UndotreeToggle<cr>', { silent = true } })

nnoremap({ '<Leader>ft', '<cmd>FloatermToggle<cr>', { silent = true } })
nnoremap({ '<A-j>', '<cmd>FloatermToggle<cr>', { silent = true } })

-- Terminal mode mappings
tnoremap({ '<Leader>ft', '<cmd>FloatermToggle<cr>', { silent = true } })
tnoremap({ '<A-j>', '<cmd>FloatermToggle<cr>', { silent = true } })
-- Go back to normal mode
tnoremap({ '<Esc>', '<C-\\><C-n>', { silent = true } })

-- Harpoon mappings
nnoremap({ '<A-h>', require('harpoon.ui').toggle_quick_menu, { silent = true } })
nnoremap({ '<Leader>m', require('harpoon.mark').add_file, { silent = true } })


local harpoon_jumpers = { '<C-h>', '<C-t>', '<C-n>', '<C-s>' }
for index, mapping in ipairs(harpoon_jumpers) do
  nnoremap({
    mapping,
    function()
      require('harpoon.ui').nav_file(index)
    end,
    { silent = true },
  })
end
