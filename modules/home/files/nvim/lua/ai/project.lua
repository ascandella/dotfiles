require('project_nvim').setup({
  -- Pattern before LSP-- better for monorepo
  detection_methods = { 'pattern', 'lsp' },
  -- Prefer git, then fall back to LSP
  patterns = { '.git' },
})
