local neotest = require('neotest')

local function init()
  neotest.setup({
    adapters = {
      require('neotest-elixir'),
      require('neotest-go'),
      require('neotest-rust'),
      require('neotest-jest')({
        jestCommand = 'yarn test --',
        cwd = function(path)
          -- Monorepo setup
          -- https://github.com/nvim-neotest/neotest-jest?tab=readme-ov-file#monorepos
          if string.find(path, '/packages/') then
            return string.match(path, '(.-/[^/]+/)test')
          end
          return vim.fn.getcwd()
        end,
      }),
    },
    icons = {
      passed = '✔',
      failed = '✖',
      running = '◴',
      skipped = 'ﰸ',
    },
    diagnostic = {
      enabled = true,
      severity = 1,
    },
    output = {
      open_on_run = true,
      enter = false,
    },
  })

  -- Test running (neotest)
  vim.keymap.set('n', '<Leader>eu', neotest.run.run, { silent = true, desc = 'Nearest test' })
  vim.keymap.set('n', '<Leader>ee', function()
    neotest.run.run(vim.fn.expand('%'))
  end, { silent = true, desc = 'Test file' })
  vim.keymap.set('n', '<Leader>ei', function()
    neotest.output.open()
  end, { silent = true, desc = 'Open test output' })
  vim.keymap.set('n', '<Leader>es', function()
    neotest.summary.toggle()
  end, { silent = true, desc = 'Toggle test summary' })
end

return {
  init = init,
}
