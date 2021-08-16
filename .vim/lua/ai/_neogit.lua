-- Neogit setup
local neogit = require('neogit')
local status = require('neogit.status')
local a = require('plenary.async_lib')

neogit.setup({
  disable_commit_confirmation = true,
  integrations = {
    diffview = true,
  },
})

local M = {}
-- https://github.com/TimUntersberger/neogit/issues/118
M.open_pr = function()
  a.scope(function()
    local remote_url = a.await(neogit.cli.config.get('remote.origin.url').call())[1]
    local repo_name = remote_url:gsub('^git@github.com:', '')
    local clean_name = repo_name:gsub('.git$', '')
    local branch = status.repo.head.branch

    local open_pr_url = string.format('https://github.com/%s/pull/new/%s', clean_name, branch)
    a.await(a.scheduler())

    if vim.fn.has('mac') == 1 then
      vim.cmd('!open ' .. open_pr_url)
    elseif vim.fn.executable('xdg-open') == 1 then
      vim.cmd('silent !xdg-open ' .. open_pr_url)
    else
      -- Fall back to copying to clipboard (e.g. for WSL)
      vim.cmd('let @+="' .. open_pr_url .. '"')
      print("PR link for '" .. branch .. "' copied to clipboard")
    end
  end)
end

return M
