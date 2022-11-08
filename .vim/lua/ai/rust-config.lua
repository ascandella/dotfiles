local rt = require('rust-tools')

rt.setup({
  server = {
    on_attach = function(client, bufnr)
      -- Hover actions
      vim.keymap.set('n', '<Leader>ra', rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set('n', '<Leader>rc', rt.code_action_group.code_action_group, { buffer = bufnr })

      require('ai/lsp-shared').on_attach(client, bufnr)
    end,
  },

  tools = {
    hover_actions = {
      auto_focus = true,
    },
    inlay_hints = {
      right_align = false,
      auto = false,
    },
    executor = require('rust-tools/executors').toggleterm,
  },

  dap = {
    -- adapter = require('dap').adapters.lldb,
    adapter = {
      type = 'executable',
      command = 'codelldb',
      name = 'rt_lldb',
    },
  },
})
