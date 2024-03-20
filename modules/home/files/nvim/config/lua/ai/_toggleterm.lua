local function init()
  require('toggleterm').setup({
    direction = 'horizontal',
    open_mapping = [[<A-j>]],
    size = function(term)
      if term.direction == 'horizontal' then
        return 20
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
  })

  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', '<C-Left>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-Up>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<A-e>', [[<C-\><C-n><C-w><C-p>]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

return {
  init = init,
}
