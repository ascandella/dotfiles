require('cloak').setup({
  enabled = true,
  patterns = {
    {
      -- Match any file starting with '.env'.
      file_pattern = { '.env*', 'credentials' },
      -- Match an equals sign and any character after it.
      cloak_pattern = '=.+',
    },
  },
})
