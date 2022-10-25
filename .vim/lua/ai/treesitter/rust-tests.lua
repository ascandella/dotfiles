-- WIP
local ts_utils = require('nvim-treesitter.ts_utils')

local test_query = vim.treesitter.parse_query(
  'rust',
  [[
    (function_item
      name: (identifier) @function_name)
  ]]
)

local function get_params()
  return {
    textDocument = vim.lsp.util.make_text_document_params(0),
    position = nil,
  }
end

local function default_handler(choice, results)
  print(vim.inspect(results))
end

local function request(bufnr, handler)
  local method = 'experimental/runnables'
  return vim.lsp.buf_request(bufnr, method, get_params(), handler)
end

local function find_test(bufnr)
  local node = ts_utils.get_node_at_cursor()
  while node:type() ~= 'function_item' and node:type() ~= 'attribute_item' do
    node = node:parent()
    if not node then
      print('No test found')
      return
    end
  end

  local current_row = unpack(vim.api.nvim_win_get_cursor(bufnr))

  for id, node, _metadata in test_query:iter_captures(node, bufnr, current_row - 1, current_row) do
    local capture_name = test_query.captures[id]
    if capture_name == 'function_name' then
      local parent = node:parent()
      if parent then
        local sibling = parent:prev_sibling()
        -- Not actually testing if it's a `#[test]` attribute, just assuming
        if sibling and sibling:type() == 'attribute_item' then
          print('Found attribute')
          local test_name = ts_utils.get_node_text(node, 0)[1]
          print(test_name)
          return
        end
      end
    end
  end

  print('Ended loop without match')
end

-- TODO:
-- [x] use TreeSitter to find nearest test function
-- [ ] get all runnables (`position` arg doesn't seem to work)
-- [ ] filter runnables by test function line
-- [ ] run it

vim.keymap.set('n', '<Leader>ll', function()
  -- request(0, default_handler)
  find_test(0)
end, { silent = true })
