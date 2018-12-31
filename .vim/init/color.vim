" Colours, please
set t_Co=256

if (has("termguicolors"))
  set termguicolors
endif

set cursorline
" hi CursorLine ctermbg=234

" colorscheme tomorrow_night_bright
" colorscheme molokai
set background=dark
colorscheme hybrid_reverse

set colorcolumn=+0
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" hi CursorColumn cterm=NONE ctermbg=234
" hi Folded ctermbg=234
" hi IncSearch cterm=none ctermbg=none ctermfg=yellow
" hi LineNr cterm=none ctermfg=229
" hi Search cterm=none ctermbg=none ctermfg=yellow
" hi TabLine cterm=underline ctermbg=none
" hi TabLineFill cterm=underline ctermbg=none
" hi TabLineSel cterm=underline ctermfg=yellow
" hi Todo ctermbg=none

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
