"
" Dvorak motion mappings
"

nnoremap t j
nnoremap n k
nnoremap s l
" Center and open folds
nnoremap l nzzzv
nnoremap L Nzzzv

"
" Window movement (doesn't work in iTerm)
"

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
imap <silent> <A-Up> <Esc>:wincmd k<CR>a
imap <silent> <A-Down> <Esc>:wincmd j<CR>a
imap <silent> <A-Left> <Esc>:wincmd h<CR>a
imap <silent> <A-Right> <Esc>:wincmd l<CR>a

nnoremap <silent> <C-Right> :wincmd l<CR>
nnoremap <silent> <C-Left> :wincmd h<CR>
nnoremap <silent> <C-Up> :wincmd k<CR>
nnoremap <silent> <C-Down> :wincmd j<CR>

" Go to previous window
nnoremap <c-e> <c-w><c-p>

" Undo break points after command, .
inoremap , ,<c-g>u
inoremap . .<c-g>u

"
" Plugin mappings
"
let mapleader = ","

map <F2> :Goyo<CR>

map <leader>- :call nerdcommenter#Comment(0,"toggle")<CR>
map <C-b> :call nerdcommenter#Comment(0,"toggle")<CR>

" FZF mappings
map <Leader>, :Files<CR>
map <Leader>f :Lines<CR>
map <Leader>n :Buffers<CR>
map <Leader>h :History<CR>

" Various other leader mappings
map <Leader>w :w<CR>

map <Leader>b  :bd<CR>
map <silent> <Leader>cl :ccl<CR>

" Yank the current buffer path into the unnamed buffer
map <silent> <leader>yp :let @" = expand("%")<cr>

noremap <silent> <Leader>rs :setlocal spell!<cr>

" Paste toggle
map <silent> <Leader>p :set paste!<CR>

" Blank newline above this one
nmap <Leader>. mmO<esc>`m
" And below
nmap <Leader>u mmo<esc>`m

" Close tab
nmap <Leader>tc :tabclose<cr>

"
" Other Mappings
"

map <Leader>4 :set sts=4<cr>:set sw=4<cr>
map <Leader>2 :set sts=2<cr>:set sw=2<cr>

" map <C-m> ciw
cnoremap sudowrite !sudo tee %<CR>

" Close the current buffer, leave the window in place
nmap <C-W>m <Plug>Kwbd

nmap <silent> <Leader>ss ms vip :sort<CR>`s
nmap <silent> <Leader>sn :set nolist!<CR>

nmap <Leader>a :Ag<space>

" Don't care about cursorcolumn for now
" nnoremap <silent> <Leader>cn :set cursorcolumn!<cr>

" Cycle relative -> normal -> no line numbers
nmap <silent> <leader>rn :exec &nu==&rnu? "se nu!" : "se rnu!"<cr>
" Toggle relative line number
nmap <silent> <leader>rr :set norelativenumber!<cr>

" Spurious shift-key failure
command W w

" Make Y consistent with D and C (instead of yy)
noremap Y y$

" Visually select the text that was most recently edited/pasted.
" Note: gv selects previously selected area.
nmap gV `[v`]

" Duplicate visual selection.
vmap D yP'<

" Backspace closes buffer
nnoremap <BS> :bd<CR>

nnoremap <F1> :GundoToggle<cr>

" To dump all mappings to a file (from:
" https://stackoverflow.com/questions/7642746/is-there-any-way-to-view-the-currently-mapped-keys-in-vim)
"
" :redir! > vim_keys.txt
" :silent verbose map
" :redir END
