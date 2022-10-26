local function init()
  require('toggleterm').setup({
    direction = 'horizontal',
  })
end

return {
  init = init,
}
