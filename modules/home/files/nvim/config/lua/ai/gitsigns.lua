local gitsigns = require('gitsigns')

local function setup()
  gitsigns.setup({
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      local gs = package.loaded.gitsigns

      map('n', '<leader>gn', function()
        if vim.wo.diff then
          return '<leader>gn'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, {
        expr = true,
        desc = 'Next git hunk',
      })

      map('n', '<leader>gp', function()
        if vim.wo.diff then
          return '<leader>gp'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, {
        expr = true,
        desc = 'Previous git hunk',
      })

      map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'Stage git hunk' })
    end,
  })
end

return {
  setup = setup,
}
