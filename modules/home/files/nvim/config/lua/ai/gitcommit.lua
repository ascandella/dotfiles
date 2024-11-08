local function get_commit_tag(branch)
  if branch == nil then
    return nil
  end

  for tag in branch:gmatch('/([%w-_]+)/') do
    return string.format('[%s] ', string.upper(tag))
  end

  return nil
end

local function handle_gitcommit_enter()
  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  local is_empty = #content > 0 and content[1] == ''

  vim.opt_local.textwidth = 72
  -- Text wrap
  vim.opt_local.formatoptions:append('t')
  -- No gutter for status
  vim.opt_local.statuscolumn = '%s'

  local found_branch = ''
  for _, line in pairs(content) do
    local _, ending = line:find('On branch ')
    if ending ~= nil then
      found_branch = line:sub(ending, -1)
    end
  end

  if found_branch and is_empty then
    local commit_tag = get_commit_tag(found_branch)
    if commit_tag ~= nil then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { commit_tag })
    end
  end

  if is_empty then
    vim.api.nvim_command('normal! 0')
    vim.api.nvim_feedkeys('A', 'n', true)
  end
end
local augroup_gitcommit = vim.api.nvim_create_augroup('gitcommit', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit' },
  group = augroup_gitcommit,
  callback = handle_gitcommit_enter,
})
