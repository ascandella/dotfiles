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
end

return {
  init = init,
}
