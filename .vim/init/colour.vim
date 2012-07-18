set background=dark
colorscheme twilight256

highlight ExtraWhitespace ctermbg=red guibg=red

:hi ColorColumn ctermbg=234
:hi CursorLine cterm=NONE ctermbg=234
:hi Folded ctermbg=234
:hi IncSearch cterm=none ctermbg=none ctermfg=yellow
:hi LineNr cterm=none ctermfg=229
:hi Search cterm=none ctermbg=none ctermfg=yellow
:hi TabLine cterm=underline ctermbg=none
:hi TabLineFill cterm=underline ctermbg=none
:hi TabLineSel cterm=underline ctermfg=yellow
:hi Todo ctermbg=none
:hi htmlLink cterm=none
:hi markdownH1 ctermfg=229
:hi markdownItalic ctermbg=none

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
set cursorline
hi CursorLine guibg=grey30

" Character color after 80 chars
if exists('+colorcolumn')
    set cc=80
endif
