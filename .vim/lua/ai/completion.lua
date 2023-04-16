-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
--

local cmp = require('cmp')
local compare = require('cmp.config.compare')
local lspkind = require('lspkind')

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local icons = {
  Copilot = '',
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

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local tabnine = require('cmp_tabnine.config')
tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = '..',
  ignored_file_types = { -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
  show_prediction_strength = false,
})

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
end

cmp.setup({
  enabled = function()
    -- disable completion in comments
    local context = require('cmp.config.context')
    -- Disable in buf-type prompts
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    if buftype == 'prompt' then
      return false
    end
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
    end
  end,
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.score,
    },
  },
  -- Don't preselect items from the menu
  preselect = cmp.PreselectMode.None,
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      -- menu = {
      --   copilot = '[Copilot]',
      --   buffer = '[Buffer]',
      --   nvim_lsp = '[LSP]',
      --   luasnip = '[LuaSnip]',
      --   nvim_lua = '[Lua]',
      -- },
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      symbol_map = icons,
    }),
  },
  mapping = {
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      -- For Copilot
      behavior = cmp.ConfirmBehavior.Replace,
      -- Only when explicitly selected
      select = false,
    }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-j>'] = cmp.mapping.complete({
      config = {
        sources = {
          { name = 'copilot' },
        },
      },
    }),
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
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        -- Tab selects and confirms if nothing is selected
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          cmp.confirm()
        elseif has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.select_next_item()
        end
      elseif vim.fn['vsnip#available']() == 1 then
        vim.api.nvim_feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '', true)
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<C-n>'] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
    ['<C-p>'] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
  },
  sources = {
    { name = 'copilot', group_index = 2, keyword_pattern = '.' },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'nvim_lsp_signature_help' },
    -- { name = 'cmp_tabnine', keyword_length = 4 },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'calc' },
    { name = 'emoji' },
    { name = 'buffer', keyword_length = 5 },
    -- { name = 'vsnip', priority = 9 },
  },
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
  sources = {
    { name = 'buffer' },
  },
})

-- Copilot integration
cmp.event:on('menu_opened', function()
  -- vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on('menu_closed', function()
  -- vim.b.copilot_suggestion_hidden = false
end)

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

vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

-- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! link CmpItemKindInterface CmpItemKindVariable
  highlight! link CmpItemKindText CmpItemKindVariable
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! link CmpItemKindMethod CmpItemKindFunction
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! link CmpItemKindProperty CmpItemKindKeyword
  highlight! link CmpItemKindUnit CmpItemKindKeyword
]])
