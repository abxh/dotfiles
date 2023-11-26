
" save/remember view - which includes folds and cursor position.
" source: https://stackoverflow.com/a/54739345
augroup remember_view
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

" don't continue comment after new line
" source: https://superuser.com/a/271024
autocmd FileType * set formatoptions-=cro
