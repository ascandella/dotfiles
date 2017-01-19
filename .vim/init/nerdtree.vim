" open up NERDTree if no file is specified
au StdinReadPre * let s:std_in=1
au VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" close NERDTree if it is the last buffer
" au BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" find the file (auto scroll)
nnoremap <silent> <leader>f :call g:NerdTreeFindToggle()<CR>
function! g:NerdTreeFindToggle()
    if g:NERDTree.IsOpen()
        exec 'NERDTreeClose'
    else
        exec 'NERDTreeFind'
    endif
endfunction
let NERDTreeWinSize = 30
let NERDTreeShowHidden = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeChDirMode = 0
"let NERDTreeIgnore = ['\.git$[[dir]]', '_tmp$[[dir]]']
let NERDTreeIgnore = ['\.git$[[dir]]', '\.pyc$']
