" rustfmt on save
let g:rustfmt_autosave = 1

let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ }

augroup rust-mapping
  autocmd!
  au FileType rust nmap gd :call LanguageClient#textDocument_definition()<CR>
  au FileType rust nmap K :call LanguageClient#textDocument_hover()<CR>
augroup END
