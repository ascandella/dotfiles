if has("gui_macvim")
  macmenu File.New\ Tab key=<nop>
  nmap <D-t> :CommandT<CR>
endif

" For pathogen, here because CL vim doesn't have python
call pathogen#runtime_append_all_bundles() 

map <F7> :GundoToggle<CR>

