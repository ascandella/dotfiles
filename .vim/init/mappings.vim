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
let mapleader = ","

map <F2> :GundoToggle<CR>
map <F1> :CommandTFlush<CR>

map <Leader>- :TComment<CR>
map <C-b>     :TComment<CR>

map <Leader>e :CommandT<CR>
map <Leader>n :CommandTBuffer<CR>

map <Leader>w :w<CR>

map <Leader>b  :bd<CR>
map <Leader>cl :ccl<CR>
map <Leader>g  :Gblame<CR>
map <Leader>q  :q<CR>

" Paste toggle
map <silent> <Leader>p : set paste!<CR>

" Fixup CSS
map <Leader>cs :g#\({\n\)\@<=#.,/}/sort<CR>

" Blank newline above this one
nmap <Leader>. mmO<esc>`m
" And below
nmap <Leader>u mmo<esc>`m

"
" Alignment
"

map <Leader>t :Tabularize/

map <Leader>: :Tabularize/:<CR>

" Align on equal signs
map <Leader>= :Tabularize/=<CR>

"
" Other Mappings
"

map <Leader>4 :set sts=4:set sw=4
map <Leader>2 :set sts=2:set sw=2

nmap <Leader>' cs"'

map <C-m> ciw
map :ws :w !sudo tee %<CR>
map <C-s> <C-w>l
imap <C-s> <Esc>:w<CR>a

" Convert hashrockets to Ruby 1.9
nmap <leader>rh :%s/\v:(\w+)\s(\s*)\=\>/\1:\2/g<cr>

" Close the current buffer, leave the window in place
nmap <C-W>m <Plug>Kwbd

" Spurious shift-key failure
map :W :w

nmap <silent> <Leader>s :set nolist!<CR>

map <Leader>a :Ack<space>
map <Leader>h :foldclose<CR>

map <silent> <Leader>cn :set nocursorcolumn <cr>

" Cycle relative -> normal -> no line numbers
nmap <silent> <leader>rn :exec &nu==&rnu? "se nu!" : "se rnu!" <cr>
" Toggle relative line number
nmap <silent> <leader>rr :set norelativenumber! <cr>
