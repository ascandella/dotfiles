local function init()
  require('trouble').setup({
    mode = 'document_diagnostics',
  })
end

return {
  init = init,
}
