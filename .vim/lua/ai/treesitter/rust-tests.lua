-- WIP
local ts_utils = require('nvim-treesitter.ts_utils')

local test_query = vim.treesitter.parse_query(
  'rust',
  [[
    (function_item
      name: (identifier) @function_name)
  ]]
)

local function get_params(winnr)
  return {
    textDocument = vim.lsp.util.make_text_document_params(winnr),
    position = nil,
  }
end

local function runnables_request(winnr, handler)
  return vim.lsp.buf_request(winnr, 'experimental/runnables', get_params(winnr), handler)
end

local function find_test(winnr)
  local node = ts_utils.get_node_at_cursor()
  while node:type() ~= 'function_item' and node:type() ~= 'attribute_item' do
    node = node:parent()
    if not node then
      print('No test found')
      return
    end
  end

  local current_row = unpack(vim.api.nvim_win_get_cursor(winnr))

  for id, node, _metadata in test_query:iter_captures(node, winnr, current_row - 1, current_row) do
    local capture_name = test_query.captures[id]
    if capture_name == 'function_name' then
      local parent = node:parent()
      if parent then
        local sibling = parent:prev_sibling()
        -- Not actually testing if it's a `#[test]` attribute, just assuming
        if sibling and sibling:type() == 'attribute_item' then
          local test_name = vim.treesitter.query.get_node_text(node, 0)[1]
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

local function run_tests_at_cursor(winnr)
  local found_test = find_test(winnr)
  if not found_test then
    return
  end

  runnables_request(winnr, function(_, results)
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
-- [x] get all runnables (`position` arg doesn't seem to work)
-- [ ] filter runnables by test function line
-- [ ] run it

return {
  run_tests_at_cursor = run_tests_at_cursor,
}
