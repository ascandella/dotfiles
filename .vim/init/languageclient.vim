let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }

let g:LanguageClient_changeThrottle = 0.5
" Disable diagnostics, use ALE for these
let g:LanguageClient_diagnosticsEnable = 0

nnoremap <silent> <leader>rh :call LanguageClient#textDocument_rename()<CR>
