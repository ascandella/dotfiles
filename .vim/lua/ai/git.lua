local ok, lspsaga_winbar = pcall(require, 'lspsaga.symbol.winbar')
local function git_blame()
  if ok then
    lspsaga_winbar.toggle()
  end
  vim.api.nvim_command('Git blame')
end

local function git_unblame()
  vim.cmd('close')
  if ok then
    lspsaga_winbar.toggle()
  end
end

return {
  git_blame = git_blame,
  git_unblame = git_unblame,
}
