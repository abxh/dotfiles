
" save/remember view - which includes folds and cursor position.
" Source: https://stackoverflow.com/a/54739345
augroup remember_view
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

