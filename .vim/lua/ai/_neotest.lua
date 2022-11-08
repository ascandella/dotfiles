local neotest = require('neotest')

local function init()
  neotest.setup({
    adapters = {
      require('neotest-elixir'),
      require('neotest-go'),
      require('neotest-rust'),
    },
    icons = {
      passed = '✔',
      failed = '✖',
      running = '◴',
      skipped = 'ﰸ',
    },
  })

  -- Test running (neotest)
  vim.keymap.set('n', '<Leader>eu', neotest.run.run, { silent = true })
  vim.keymap.set('n', '<Leader>ee', function()
    neotest.run.run(vim.fn.expand('%'))
  end, { silent = true })
  vim.keymap.set('n', '<Leader>eo', function()
    neotest.output.open()
  end, { silent = true })
end

return {
  init = init,
}
