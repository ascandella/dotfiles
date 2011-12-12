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


" Changed my mind: I like ; as repeat find
" nnoremap ; :

iabbrev crjeff Reviewed-by: Jeff Scherpelz <jeff.scherpelz@socrata.com>
iabbrev crrobert Reviewed-by: Robert Macomber <robert.macomber@socrata.com>
iabbrev crpaul Reviewed-by: Paul Paradise <paul.paradise@socrata.com>
iabbrev crclint Reviewed-by: Clint Tseng <clint.tseng@socrata.com>
iabbrev crchi Reviewed-by: Chi Tang <chi.tang@socrata.com>
iabbrev crme Reviewed-by: Aiden Scandella <aiden.scandella@socrata.com>
iabbrev crchris Reviewed-by: Chris Metcalf <chris.metcalf@socrata.com>
iabbrev crmichael Reviewed-by: Michael Chui <michael.chui@socrata.com>
iabbrev crrohan Reviewed-by: Rohan Singh <rohan.singh@socrata.com>

" Programming abbreviations
iabbrev endd <%- end -%>

set expandtab
set softtabstop=4
set sw=4
set cindent
set smartindent
set autoindent
set relativenumber
set ruler
" Hide tool bar for mvim / gvim
set go=a
set go-=Trm

set hidden
set viminfo='20,\"500
set history=50
set bs=indent,eol,start
set ignorecase

" Start searching incrementally (immediately)
set incsearch
" Highlighting is obnoxious
set nohlsearch

map <F2> :GundoToggle<CR>
map <F1> :CommandTFlush<CR>
map <C-t> :CommandT<CR>
map <C-n> :CommandTBuffer<CR>

" I never use :ex, this is always by accident
map Q :set sts=4:set sw=4

" map <C-m> :MRU<CR>
map <S-Esc> :bd<CR>
map <C-b> :TComment<CR>
map <C-c> :silent !gitx<CR>
map :ws :w !sudo tee %<CR>
map <C-s> <C-w>l
imap <C-s> <Esc>:w<CR>a
colorscheme peaksea
" colorscheme desert

set scrolloff=3
set listchars=tab:>-,trail:_,eol:$
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

" let mapleader = "\_"
map <Leader>a :Ack<space>
" Close quicfix window
map <F8> :ccl<CR>
map! <Leader>e <C-x><C-n>
map <Leader>w :Gwrite<CR>


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

" Zen CodinG
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
let g:user_zen_settings = {
\ 'indentation': '  '
\}

" Buffer remains hidden on deletion
set hidden
call pathogen#runtime_append_all_bundles()

syntax on

filetype on
filetype plugin on
filetype indent on

nmap <C-W>m <Plug>Kwbd

if has("autocmd")
    " Delete fugitive buffers on hide
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif
" Navigation
" Text-bubbling (using unimpaired for boundaries)
" unmap <Leader>n
" unmap <Leader>t

" nnoremap <Leader>n [e
" nmap <Leader>t ]e
" imap <Leader>n [e
" imap <Leader>t ]e
" 
" " Visual mode
" vnoremap <Leader><Up> [egv
" unmap <A-Down>
" vnoremap <A-Down> ]egv
" vnoremap <Leader>n [egv
" vnoremap <Leader>t ]egv
"
"

" au FileType html,xml,erb so ~/.vim/bundle/html-autoclose/ftplugin/html_autoclosetag.vim

let g:delimitMate_autoclose=0
" Ignore files
set wildignore+=*.o,*.obj,.git,dev-server/**,*.class,public/packages/**,public/assets/**,vendor/rails/**,*.jar,*.zip,*.md5,target/**,mvn-local-repo/**,public/images/**,public/stylesheets/images/**,vendor/**
