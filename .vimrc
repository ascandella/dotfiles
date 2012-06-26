set nocompatible
set nobackup
set noswapfile
set pastetoggle=<F3>
set laststatus=1

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

set expandtab
set softtabstop=4
set sw=4
set cindent
set smartindent
set autoindent

" Note: Vim 7.3+ only
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
map <Leader>4 :set sts=4:set sw=4
map <Leader>2 :set sts=2:set sw=2

map <C-m> ciw
map <S-Esc> :bd<CR>
map <C-b> :TComment<CR>
" map <C-c> :silent !gitx<CR>
map :ws :w !sudo tee %<CR>
map <C-s> <C-w>l
imap <C-s> <Esc>:w<CR>a
set background=dark
colorscheme peaksea
" colorscheme desert

" Make :W save, from holding down the shift key
map :W :w

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


let mapleader = "\\"
" nmap " " <Nop>

map <C-Tab> :bnext<cr>

map <Leader>a :Ack<space>
map <Leader>h :foldclose<CR>
" map <Leader>t :foldopen<CR>
" Close quicfix window
map <F8> :ccl<CR>
" map! <Leader>e <C-x><C-n>
" map <Leader>w :Gwrite<CR>


" Allow yanking/pasting directly to/from OS X clipboard
" set clipboard=unnamed

" if has('gui_running')
"     set transparency=8
" endif

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 0
" let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
" Single click to select buffer
let g:miniBufExplUseSingleClick = 1

let g:CommandTMatchWindowAtTop = 1

" Zen Coding
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
let g:user_zen_settings = {
\ 'indentation': '  '
\}

" Turn on fancy symbols for powerline status bar
if has('gui_running')
  let g:Powerline_symbols = 'fancy'
endif

" Character color after 80 chars
if exists('+colorcolumn')
    set cc=80
endif

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

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
imap <silent> <A-Up> <Esc>:wincmd k<CR>a
imap <silent> <A-Down> <Esc>:wincmd j<CR>a
imap <silent> <A-Left> <Esc>:wincmd h<CR>a
imap <silent> <A-Right> <Esc>:wincmd l<CR>a
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
fun! <SID>StripTrailingWhitespaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

let g:delimitMate_autoclose=0

" Use JSL configuration from my home dir
let g:syntastic_javascript_jsl_conf="-conf ~/.jsl.conf"

" Ignore files
set wildignore+=*.o,*.obj,.git,dev-server/**,*.class,public/packages/**,public/assets/**,vendor/rails/**,*.jar,*.zip,*.md5,target/**,mvn-local-repo/**,public/images/**,public/stylesheets/images/**,vendor/**,app/assets

" save and load views (fold lists)
" au BufWinLeave * silent! mkview
" au BufWinEnter * silent! loadview

