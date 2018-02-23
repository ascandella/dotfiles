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

" Rolling escape, dvorak friendly
inoremap jk <esc>

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

map <leader>- :call NERDComment(0,"toggle")<C-m><Paste>
map <C-b> :call NERDComment(0,"toggle")<C-m><Paste>

" FZF mappings
map <Leader>, :Files<CR>
map <Leader>e :Files<CR>
map <Leader>n :Buffers<CR>
map <Leader>h :History<CR>

" Remap gitgutter leader-h
nmap <Leader>mp <Plug>GitGutterPreviewHunk
nmap <Leader>mr <Plug>GitGutterPreviewHunk
nmap <Leader>ms <Plug>GitGutterStageHunk
nmap <Leader>mu <Plug>GitGutterUndoHunk

" Git mappings
map <Leader>g :Gblame<CR>

" Various other leader mappings
map <Leader>w :w<CR>

map <Leader>b  :bd<CR>
map <Leader>cl :ccl<CR>
"map <Leader>q  :q<CR>

map <Leader>l :setlocal spell spelllang=en_us<cr>
noremap <silent> <Leader>r :setlocal spell!<cr>

" Send selected text to clipper
" Todo make sure this is compatible with new clip system
if !executable('lemonade')
  nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>
end

" Paste toggle
map <silent> <Leader>p : set paste!<CR>

" Fixup CSS
autocmd FileType css map <Leader>cs :g#\({\n\)\@<=#.,/}/sort<CR>

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
autocmd FileType ruby nmap <leader>rh :%s/\v:(\w+)\s(\s*)\=\>/\1:\2/g<cr>

" Close the current buffer, leave the window in place
nmap <C-W>m <Plug>Kwbd

nmap <silent> <Leader>s :set nolist!<CR>

nmap <Leader>a :Ag<space>

" Don't care about cursorcolumn for now
" nnoremap <silent> <Leader>cn :set cursorcolumn!<cr>

" Cycle relative -> normal -> no line numbers
nmap <silent> <leader>rn :exec &nu==&rnu? "se nu!" : "se rnu!"<cr>
" Toggle relative line number
nmap <silent> <leader>rr :set norelativenumber!<cr>

" Easier inline save
imap ,w <Esc>:w<cr>a

" Spurious shift-key failure
map :W :w

" Make Y consistent with D and C (instead of yy)
noremap Y y$

" Visually select the text that was most recently edited/pasted.
" Note: gv selects previously selected area.
nmap gV `[v`]

" Duplicate visual selection.
vmap D yP'<

" Backspace closes buffer
nnoremap <BS> :bd<CR>

" nmap <Tab> >>
nmap <S-Tab> <<

" To dump all mappings to a file (from:
" https://stackoverflow.com/questions/7642746/is-there-any-way-to-view-the-currently-mapped-keys-in-vim)
"
" :redir! > vim_keys.txt
" :silent verbose map
" :redir END
