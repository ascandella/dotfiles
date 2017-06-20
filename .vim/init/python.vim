"
" Python editing preferences
"

let python_highlight_all = 1

autocmd FileType python iabbrev <silent> _fu from __future__ import absolute_import

let g:jedi#usages_command = "<leader>u"
let g:jedi#force_py_version = "auto"

" Per https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim,
" hardcode Python paths so that virtualenvs don't need the neovim package or
" --system-site-packages, both of which I've tried and are ugly.
"if executable('python2')
  "let g:python_host_prog = execute('!which python2')
"end
"if executable('python3')
  "let g:python3_host_prog = execute('!which python3')
"end
