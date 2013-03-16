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
" Other Mappings
"

map <Leader>4 :set sts=4:set sw=4
map <Leader>2 :set sts=2:set sw=2

nmap <Leader>' cs"'

map <C-m> ciw
map :ws :w !sudo tee %<CR>

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

" Easier inline save
imap ,w <Esc>:w<cr>a


" Bracketed paste mode
let &t_ti .= "\e[?2004h"
let &t_te .= "\e[?2004l"
let &pastetoggle = "\e[201~"

function! XTermPasteBegin(ret)
  set paste
  return a:ret
endfunction

noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
cnoremap <special> <Esc>[200~ <nop>
cnoremap <special> <Esc>[201~ <nop>

" Make Y consistent with D and C (instead of yy)
noremap Y y$

" Visually select the text that was most recently edited/pasted.
" Note: gv selects previously selected area.
nmap gV `[v`]

" Duplicate visual selection.
vmap D yP'<

" Backspace closes buffer
nnoremap <BS> :bd<CR>

"
" Alignment
"

" map <Leader>t :Tabularize/

" Align on equal signs
map <Leader>= :Tabularize/=<CR>

nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
" key => value
nmap <Leader>t> :Tabularize /=><CR>
vmap <Leader>t> :Tabularize /=><CR>
" key: value
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>
" Ruby symbols
nmap <Leader>ts :Tabularize /:/l1c0l0<CR>
vmap <Leader>ts :Tabularize /:/l1c0l0<CR>

highlight clear SignColumn

nmap <Leader>9 :RainbowParenthesesToggle <CR>
