local cb = require'diffview.config'.diffview_callback

require('diffview').setup({
  diff_binaries = false,
  file_panel = {
    use_icons = true,
  },
  key_bindings = {
    file_panel = {
      ["s"] = cb("toggle_stage_entry"),
    },
  },
})
