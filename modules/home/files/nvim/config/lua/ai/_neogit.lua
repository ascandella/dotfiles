-- Neogit setup
local neogit = require('neogit')
local a = require('plenary.async')

neogit.setup({
  disable_commit_confirmation = true,
  disable_hint = true,
  -- Use insert for commit messages
  disable_insert_on_commit = true,
  graph_style = 'unicode',
  kind = 'tab',
  integrations = {
    telescope = true,
    diffview = true,
  },
  sections = {
    -- Don't care about stashes in this view
    stashes = {
      hidden = true,
    },
  },
  signs = {
    -- { CLOSED, OPENED }
    hunk = { '', '' },
    item = { '', '' },
    section = { '', '' },
  },
})

local M = {}
-- https://github.com/TimUntersberger/neogit/issues/118
M.open_pr = function()
  a.run(function()
    local remote_url = neogit.cli.config.get('remote.origin.url').call().stdout[1]
    local branch = require('neogit.lib.git.branch').current()
    local repo_name
    local code_forge = 'github.com'
    local pull_url = 'NOTIMPLEMENTED'
    if string.find(remote_url, 'github.com') then
      repo_name = remote_url:gsub('^git@github.com:', '')
      pull_url = string.format('pull/new/%s', branch)
    elseif string.find(remote_url, 'gitlab.com') then
      repo_name = remote_url:gsub('^git@gitlab.com:', '')
      code_forge = 'gitlab.com'
      pull_url = string.format('merge_requests/new?merge_request[source_branch]=%s', branch)
    end
    local clean_name = repo_name:gsub('.git$', '')

    local open_pr_url = string.format('https://%s/%s/%s', code_forge, clean_name, pull_url)
    a.util.scheduler()

    if vim.fn.has('mac') == 1 then
      vim.cmd('silent !open "' .. open_pr_url .. '"')
    elseif vim.fn.executable('xdg-open') == 1 then
      vim.cmd('silent !xdg-open ' .. open_pr_url)
    else
      -- Fall back to copying to clipboard (e.g. for WSL)
      vim.cmd('let @+="' .. open_pr_url .. '"')
      print("PR link for '" .. branch .. "' copied to clipboard")
    end
  end)
end

-- local group = vim.api.nvim_create_augroup('ai/neogit', { clear = true })
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'NeogitPushComplete',
--   group = group,
--   callback = neogit.close,
-- })

return M
