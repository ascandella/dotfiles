"
" Python editing preferences
"

let python_highlight_all = 1

autocmd FileType python iabbrev <silent> ipdb import ipdb ; ipdb.set_trace()
autocmd FileType python iabbrev <silent> _fu from __future__ import absolute_import
