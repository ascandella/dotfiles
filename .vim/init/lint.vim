" call Neomake on save for every file
call neomake#configure#automake({
  \ 'TextChanged': {},
  \ 'InsertLeave': {},
  \ 'BufWritePost': {'delay': 0},
  \ 'BufWinEnter': {},
  \ }, 500)
