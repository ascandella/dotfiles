"
" Lightline is the latest powerline
"
let g:lightline = {
  \ 'colorscheme': 'material_vim',
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \ },
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
  \ }


function! LightlineMode()
  return expand('%:t') ==# '__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ &filetype ==# 'fzf' ? 'FZF' :
        \ lightline#mode()
endfunction

" Don't need mode with lightline enabled
set noshowmode
