set nocompatible
set nobackup
set noswapfile
set pastetoggle=<F3>

" Dvorak mappings
no h h
no t j
no n k
no s l
no S :
no l n
no L N

nnoremap ; :

iabbrev crchris Reviewed-by: Chris Metcalf <chris.metcalf@socrata.com>
iabbrev crjeff Reviewed-by: Jeff Scherpelz <jeff.scherpelz@socrata.com>
iabbrev crrobert Reviewed-by: Robert Macomber <robert.macomber@socrata.com>
iabbrev crpaul Reviewed-by: Paul Paradise <paul.paradise@socrata.com>
iabbrev crsam Reviewed-by: Sam Gibson <sam.gibson@socrata.com>
iabbrev crclint Reviewed-by: Clint Tseng <clint.tseng@socrata.com>
iabbrev crchi Reviewed-by: Chi Tang <chi.tang@socrata.com>
iabbrev crme Reviewed-by: Aiden Scandella <aiden.scandella@socrata.com>
iabbrev crmay Reviewed-by: May Peria <may.peria@socrata.com>
iabbrev crtodd Reviewed-by: Todd Stavish <todd.stavish@socrata.com>

set expandtab
set softtabstop=4
set sw=4
set cindent
set smartindent
set autoindent
set number
set ruler
" Hide tool bar for mvim / gvim
set go-=T

set hidden
set viminfo='20,\"500
set history=50
set bs=indent,eol,start
set ignorecase

" Start searching incrementally (immediately)
set incsearch
" Highlighting is obnoxiouz
" set hlsearch


map <F2> :CommandTFlush<CR>
map <C-t> :CommandT<CR>
map <C-n> :CommandTBuffer<CR>

map <F10> :FufFile **/<CR>
map <C-m> :MRU<CR>
map :ws :w !sudo tee %<CR>
map <S-Esc> :bd<CR>
map <C-b> :TComment<CR>
map <C-c> :silent !gitx<CR>
colorscheme herald
" colorscheme desert

set scrolloff=3
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <Leader>s :set nolist!<CR>

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
set cursorline
hi CursorLine guibg=grey30

function! AckGrep(command)
    cexpr system("ack " . a:command)
    cw " show quickfix window already
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)

let mapleader = "\\"
map <Leader>a :Ack<space>
" Close quicfix window
map <F8> :ccl<CR>
map! <Leader>e <C-x><C-n>


" Allow yanking/pasting directly to/from OS X clipboard
" set clipboard=unnamed

" if has('gui_running')
"     set transparency=8
" endif

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

let g:CommandTMatchWindowAtTop = 1

call pathogen#runtime_append_all_bundles()


syntax on

filetype on
filetype plugin on
filetype indent on

" Ignore files
set wildignore+=*.o,*.obj,.git,*.class,vendor/rails/**,*.jar,*.zip,*.md5,public/packages/,target/**,mvn-local-repo/**
