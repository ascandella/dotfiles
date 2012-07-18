"
" Dvorak motion mappings
"

no h h
no t j
no n k
no s l
no S :
no l n
no L N

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



"
" Plugin mappings
"

map <F2> :GundoToggle<CR>
map <F1> :CommandTFlush<CR>

map <C-b> :TComment<CR>
map <C-t> :CommandT<CR>
map <C-n> :CommandTBuffer<CR>

map <Leader>e :CommandT<CR>
map <Leader>n :CommandTBuffer<CR>

"
" Other Mappings
"

let mapleader = ","

map <Leader>4 :set sts=4:set sw=4
map <Leader>2 :set sts=2:set sw=2

map <C-m> ciw
map <S-Esc> :bd<CR>
map :ws :w !sudo tee %<CR>
map <C-s> <C-w>l
imap <C-s> <Esc>:w<CR>a

" Close the current buffer, leave the window in place
nmap <C-W>m <Plug>Kwbd

" Spurious shift-key failure
map :W :w

nmap <silent> <Leader>s :set nolist!<CR>

map <Leader>a :Ack<space>
map <Leader>h :foldclose<CR>
map <F8> :ccl<CR>
