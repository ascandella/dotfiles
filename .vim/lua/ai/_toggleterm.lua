local function init()
  require('toggleterm').setup({
    direction = 'horizontal',
    open_mapping = [[<A-j>]],
  })
end

return {
  init = init,
}
