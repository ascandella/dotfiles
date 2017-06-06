" Git Commit message hooks
"
"" Arcanist (phabricator) for Uber
"
autocmd FileType gitcommit nnoremap gr /Reviewers:<CR>A
autocmd BufRead,BufNewFile new-commit nnoremap gr /Reviewers:<CR>A
