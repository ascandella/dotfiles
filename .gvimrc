if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :CommandT<CR>
elseif has("gui_gtk2")
  set guifont=Monospace\ 9
endif
