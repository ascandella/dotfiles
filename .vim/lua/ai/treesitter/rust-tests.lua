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

local function runnables_request(bufnr, handler)
  return vim.lsp.buf_request(bufnr, 'experimental/runnables', get_params(), handler)
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
          local test_name = ts_utils.get_node_text(node, 0)[1]
          return {
            name = test_name,
            start = node:start(),
            ['end_'] = node:end_(),
          }
        end
      end
    end
  end

  print('Ended loop without match')
end

local function find_and_run_tests(bufnr)
  local found_test = find_test(bufnr)
  if not found_test then
    return
  end
  runnables_request(bufnr, function(_, results)
    if results == nil then
      return
    end
    for _, runnable in ipairs(results) do
      -- package level stuff not interesting and doesn't include `location`
      if runnable.location then
        print(vim.inspect(runnable.label))
        print(vim.inspect(runnable.location))
      end
    end
  end)
end

-- TODO:
-- [x] use TreeSitter to find nearest test function
-- [ ] get all runnables (`position` arg doesn't seem to work)
-- [ ] filter runnables by test function line
-- [ ] run it

vim.keymap.set('n', '<Leader>ll', function()
  find_and_run_tests(0)
end, { silent = true })
