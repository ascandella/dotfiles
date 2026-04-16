-- rustaceanvim replaces the archived simrat39/rust-tools.nvim.
--
-- It auto-configures rust-analyzer (do NOT also `vim.lsp.enable('rust_analyzer')`
-- — rustaceanvim does that itself). Extra settings are set via the global
-- `vim.g.rustaceanvim` table before the plugin loads.

local on_attach = require('ai/lsp-shared').on_attach

vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      auto_focus = true,
    },
    -- rustaceanvim uses Neovim's built-in inlay hint support (vim.lsp.inlay_hint)
    -- rather than a custom implementation.
  },
  server = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- Hover actions and code action groups moved to :RustLsp commands.
      vim.keymap.set('n', '<Leader>ra', function()
        vim.cmd.RustLsp('hover', 'actions')
      end, { buffer = bufnr, desc = 'Rust hover actions' })
      vim.keymap.set('n', '<Leader>rc', function()
        vim.cmd.RustLsp('codeAction')
      end, { buffer = bufnr, desc = 'Rust code action group' })
    end,
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = false,
          },
        },
      },
    },
  },
  dap = {
    adapter = {
      type = 'executable',
      command = 'codelldb',
      name = 'rt_lldb',
    },
  },
}
