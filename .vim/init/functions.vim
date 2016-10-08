"
" Strip trailing whitespace on save
"

fun! <SID>StripTrailingWhitespaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfun

augroup Whitespace
augroup END

" enable toggling
function! ToggleWhitespaceAutoGroup()
    if !exists('#Whitespace#BufWritePre')
        augroup Whitespace
            autocmd!
            autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
        augroup END
    else
        augroup Whitespace
            autocmd!
        augroup END
    endif
endfunction

nnoremap <silent> <leader>ts :call ToggleWhitespaceAutoGroup()<CR>
