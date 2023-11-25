
" save/remember view - which includes folds and cursor position.
" Source: https://stackoverflow.com/a/54739345
augroup remember_view
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

" highlight yank
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=700})
augroup END

" don't continue comment after new line
autocmd FileType * set formatoptions-=cro
