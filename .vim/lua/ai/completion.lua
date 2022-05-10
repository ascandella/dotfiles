-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
--

local cmp = require('cmp')

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '⌘',
  Field = 'ﰠ',
  Variable = '',
  Class = 'ﴯ',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '塞',
  Value = '',
  Enum = '',
  Keyword = '廓',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = 'פּ',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

cmp.setup({
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.kind = icons[vim_item.kind]
      vim_item.menu = ({
        spell = '[Spell]',
        buffer = '[Buffer]',
        calc = '[Calc]',
        emoji = '[Emoji]',
        nvim_lsp = '[LSP]',
        path = '[Path]',
        look = '[Look]',
        treesitter = '[treesitter]',
        luasnip = '[LuaSnip]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Latex]',
        cmp_tabnine = '[Tab9]',
      })[entry.source.name]

      return vim_item
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, {
      'i',
      's',
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available']() == 1 then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true),
          '',
          true
        )
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'calc' },
    { name = 'emoji' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'nvim_lsp_signature_help' },
  },
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
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

-- Add SQL completion via dadbod
vim.cmd([[
  augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
  augroup END
]])
