-- project.nvim (DrKJeff16 fork) renamed its module from `project_nvim` to
-- `project` and dropped the `detection_methods` option — LSP detection is
-- now always optionally active via `lsp.enabled`, and pattern matching
-- always runs with the configured `patterns`.
require('project').setup({
  patterns = { '.git' },
  lsp = { enabled = true },
})
