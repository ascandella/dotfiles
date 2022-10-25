-- From: https://github.com/justinrassier/dotfiles/blob/223bd1007773ff8ef2df7e8c31087c3895a793de/nvim/.config/nvim/lua/jr/custom/tailwind.lua
local ts_utils = require('nvim-treesitter.ts_utils')

local attribute_query = vim.treesitter.parse_query(
  'tsx',
  [[
  (jsx_element
    (jsx_opening_element (jsx_attribute
       (
          (property_identifier) @attr_name)
          (#eq? @attr_name "className")
          (string (string_fragment) @attr_value)
        )
      )
    )
  ]]
)

local attribute_self_closing_query = vim.treesitter.parse_query(
  'tsx',
  [[
  (jsx_self_closing_element
    (jsx_attribute
       (
          (property_identifier) @attr_name)
          (#eq? @attr_name "className")
          (string (string_fragment) @attr_value)
        )
    )
  ]]
)

local element_query = vim.treesitter.parse_query(
  'tsx',
  [[
  (jsx_element
    (jsx_opening_element
      (identifier) @tag_name))
  ]]
)

local element_self_closing_query = vim.treesitter.parse_query(
  'tsx',
  [[
  (jsx_self_closing_element
    (identifier) @tag_name)
  ]]
)

local attribute_queries = {
  jsx_element = attribute_query,
  jsx_self_closing_element = attribute_self_closing_query,
}

local element_queries = {
  jsx_element = element_query,
  jsx_self_closing_element = element_self_closing_query,
}

local M = {}
function M.add_or_insert_class_attribute()
  local node = ts_utils.get_node_at_cursor()

  if not node then
    return
  end

  -- go up the tree until you get to the nearest element
  while node:type() ~= 'jsx_element' and node:type() ~= 'jsx_self_closing_element' do
    node = node:parent()
    if not node then
      print('No JSX element found')
      return
    end
  end

  local current_row = unpack(vim.api.nvim_win_get_cursor(0))

  -- in the case the element already has a class attribute
  local attribute_query_ = attribute_queries[node:type()]
  local element_query_ = element_queries[node:type()]

  for id, node, _metadata in attribute_query_:iter_captures(node, 0, current_row - 1, current_row) do
    local capture_name = attribute_query_.captures[id] -- name of the capture in the query
    local start_row, _start_col, _end_row, end_col = node:range()
    -- set cursor at the end of attr_value
    if capture_name == 'attr_value' then
      -- set the cursor to the end of the class attribute string value (before the closing quote)
      vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col })
      -- go into insert mode and add a space to be ready to start adding new classes
      vim.api.nvim_feedkeys('i ', 'n', false)
      return
    end
  end

  -- if the element doesn't have a class attribute, then add one
  for _id, node, _metadata in element_query_:iter_captures(node, 0, current_row - 1, current_row) do
    local start_row, start_col, end_row, end_col = node:range()
    vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col - 1 })

    -- go into insert mode and add a a class attribute
    vim.api.nvim_feedkeys('a className="" ', 'n', false)

    -- move cursor back to the middle of the quotes
    local left_key = vim.api.nvim_replace_termcodes('<Left><left>', true, true, true)
    vim.api.nvim_feedkeys(left_key, 'n', false)
  end
end

return M
