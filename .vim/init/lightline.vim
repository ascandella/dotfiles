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

let g:lightline.component_expand = {
  \  'linter_checking': 'lightline#ale#checking',
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ }

let g:lightline.component_type = {
  \     'linter_checking': 'left',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'left',
  \ }

let g:lightline.active = {
  \ 'right': [
  \   [ 'linter_checking', 'linter_errors', 'linter_warnings' ],
  \   [ 'lineinfo' ],
  \   [ 'percent' ],
  \   [ 'filetype' ],
  \ ],
  \ }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

function! LightlineMode()
  return expand('%:t') ==# '__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ &filetype ==# 'fzf' ? 'FZF' :
        \ lightline#mode()
endfunction

" Don't need mode with lightline enabled
set noshowmode
