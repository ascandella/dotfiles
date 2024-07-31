local notify = require('notify')

notify.setup({
  render = 'wrapped-compact',
})

local banned_messages = {
  -- https://github.com/nvimdev/lspsaga.nvim/issues/1295
  -- https://github.com/rcarriga/nvim-notify/issues/114#issuecomment-1179754969
  'No information available',
}

vim.notify = function(msg, ...)
  for _, banned in ipairs(banned_messages) do
    if msg == banned then
      return
    end
  end
  notify(msg, ...)
end
