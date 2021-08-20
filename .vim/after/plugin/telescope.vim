if exists(':Telescope')
  unmap <Leader>f
  " Find files using Telescope command-line sugar.

  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  " nnoremap <leader>, <cmd>Telescope find_files<cr>
endif
