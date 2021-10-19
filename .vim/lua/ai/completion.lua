-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
--

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'emoji' },
  },
})

vim.o.completeopt = 'menu,menuone,noselect'

-- Disable in commit modes
vim.cmd([[
augroup NvimCmpGitCommit
  au!
  au FileType NeogitCommitMessage lua require('cmp').setup.buffer { enabled = false }
  au FileType gitcommit lua require('cmp').setup.buffer { enabled = false }
augroup END
]])
