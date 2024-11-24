local function get_visual_selection()
  if vim.fn.visualmode() ~= 'v' then
    return ''
  end
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  if s_start[2] == s_end[2] and s_start[3] == s_end[3] then
    return ''
  end
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

  if n_lines ~= 1 then
    return ''
  end
  local selection = string.sub(lines[n_lines], s_start[3], s_end[3])
  if selection:match('%s') == nil then
    return selection
  end
  return ''
end

local function create_new_buffer(opts)
  local bufdir = vim.fn.expand('%:p:h')
  local fname = opts.args
  local keys = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(keys, 'x', false)
  fname = get_visual_selection()
  local function editfile(name)
    local newpath = vim.fn.resolve(bufdir .. '/' .. name)
    vim.cmd('edit ' .. newpath)
  end
  if fname ~= '' then
    editfile(fname)
    return
  end

  fname = vim.ui.input({
    prompt = 'Enter name: ',
    default = '',
  }, function(input)
    vim.defer_fn(function()
      vim.cmd('echom ""')
    end, 0)
    editfile(input)
  end)
end

vim.api.nvim_create_user_command(
  'BufInCurrentDirectory',
  create_new_buffer,
  { nargs = '*', desc = 'Create new buffer from name in PWD', range = true }
)

vim.keymap.set(
  'v',
  '<Leader>e',
  '<cmd>BufInCurrentDirectory<CR>',
  { desc = 'Create file in current directory', silent = true }
)
