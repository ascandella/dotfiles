local k = require("astronauta.keymap")
local nnoremap = k.nnoremap

nnoremap { '-', require('telescope.builtin').file_browser, { silent = true } }
nnoremap { '<Leader>,', require('telescope-config').project_files , { silent = true } }

nnoremap { '<Leader>h', require('telescope-config').frecency, { silent = true } }

nnoremap { '<Leader>n', require('telescope.builtin').buffers, { silent = true} }
nnoremap { '<Leader>gf', require('telescope.builtin').git_status, { silent = true} }

nnoremap { '<Leader>a', require('telescope-config').livegrep_project, { silent = true} }

nnoremap { '<Leader>fs', require('telescope-config').grep_string_hidden, { silent = true} }

nnoremap { '<Leader>S', require('spectre').open, { silent = true} }

nnoremap { '<Leader>sw', require('spectre').open_visual, { silent = true} }

nnoremap { '<Leader>sp', require('spectre').open_file_search, { silent = true} }

nnoremap { '<Leader>gg', '<cmd>Neogit<cr>', { silent=true } }

nnoremap { '<Leader>u', '<cmd>UndotreeToggle<cr>', { silent = true }}
