local codecompanion = require('codecompanion')

local progress = require('fidget.progress')

-- https://codecompanion.olimorris.dev/usage/ui.html
local fidget_progress = {}

function fidget_progress:init()
  local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestStarted',
    group = group,
    callback = function(request)
      local handle = fidget_progress:create_progress_handle(request)
      fidget_progress:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    group = group,
    callback = function(request)
      local handle = fidget_progress:pop_progress_handle(request.data.id)
      if handle then
        fidget_progress:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

fidget_progress.handles = {}

function fidget_progress:store_progress_handle(id, handle)
  fidget_progress.handles[id] = handle
end

function fidget_progress:pop_progress_handle(id)
  local handle = fidget_progress.handles[id]
  fidget_progress.handles[id] = nil
  return handle
end

function fidget_progress:create_progress_handle(request)
  return progress.handle.create({
    title = ' Requesting assistance (' .. request.data.strategy .. ')',
    message = 'In progress...',
    lsp_client = {
      name = fidget_progress:llm_role_title(request.data.adapter),
    },
  })
end

function fidget_progress:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= '' then
    table.insert(parts, '(' .. adapter.model .. ')')
  end
  return table.concat(parts, ' ')
end

function fidget_progress:report_exit_status(handle, request)
  if request.data.status == 'success' then
    handle.message = 'Completed'
  elseif request.data.status == 'error' then
    handle.message = ' Error'
  else
    handle.message = '󰜺 Cancelled'
  end
end

local function setup()
  fidget_progress:init()
  codecompanion.setup({
    strategies = {
      chat = {
        adapter = 'ollama',
        keymaps = {
          send = {
            modes = { n = '<A-enter>', i = '<A-enter>' },
          },
          close = {
            modes = { n = '<C-c>', i = '<C-c>' },
          },
          -- Add further custom keymaps here
        },
      },
      inline = {
        adapter = 'ollama',
      },
    },
    display = {
      action_palette = {
        provider = 'telescope',
      },
    },
    adapters = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          env = {
            url = 'http://ollama.lfp:11434',
          },
          parameters = {
            sync = true,
          },
        })
      end,
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'v' }, '<Leader>ct', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

  -- Expand 'cc' into 'CodeCompanion' in the command line
  vim.cmd([[cab cc CodeCompanion]])
end

return {
  setup = setup,
}
