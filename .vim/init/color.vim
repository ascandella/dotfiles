" Colours, please
set t_Co=256

if (has("termguicolors"))
  set termguicolors
endif

set cursorline
" hi CursorLine ctermbg=234

set background=dark
colorscheme OceanicNext

set colorcolumn=+0

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

" Disable syntax for large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif
