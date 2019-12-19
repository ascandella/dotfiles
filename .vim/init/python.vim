"
" Python editing preferences
"

let python_highlight_all = 1

autocmd FileType python iabbrev <silent> _fu from __future__ import absolute_import

let g:jedi#force_py_version = "auto"

let g:autopep8_disable_show_diff=1
" autocmd BufWritePre *.py call Autopep8()

" Per https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim,
" hardcode Python paths so that virtualenvs don't need the neovim package or
" --system-site-packages, both of which I've tried and are ugly.
"if executable('python2')
  "let g:python_host_prog = execute('!which python2')
"end
"if executable('python3')
  "let g:python3_host_prog = execute('!which python3')
"end

augroup python-mapping
  autocmd!
  au FileType python nmap <leader>gd :Ag def <c-r><c-w><cr>
  au FileType python nmap <leader>cf <Plug>(coc-format)
  au FileType python nmap <silent> <leader>rp :Semshi rename<cr>
  au FileType python nmap <silent> <leader>n :Semshi goto function next<cr>
  au FileType python nmap <silent> <leader>cp :Semshi goto class prev<cr>
  au FileType python nmap <silent> <leader>cn :Semshi goto class next<cr>
augroup END
