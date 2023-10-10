local notify = require('notify')

notify.setup({
  render = 'wrapped-compact',
})

vim.notify = notify
