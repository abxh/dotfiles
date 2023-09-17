" vim: fdm=marker: foldlevel=0

" functions {{{

" toggle between number and relativenumber {{{
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
" }}}

" delete old backups {{{
" https://gist.github.com/sirlancelot/602340/8f374324d3c0ab8daa9012a86f02446dd2e2a503
function! s:DeleteOldBackups()
  " Delete backups over 14 days old
  let l:Old = (60 * 60 * 24 * 14)
  let l:BackupFiles = split(glob(&backupdir."/*", 1)."\n".glob(&backupdir."/.[^.]*",1), "\n")
  let l:Now = localtime()
  let l:DelCmd = "trash-put -f {}"

  for l:File in l:BackupFiles
    if (l:Now - getftime(l:File)) > l:Old
      if !empty(l:DelCmd)
	let l:Command = substitute(l:DelCmd, '{}', shellescape(l:File), "")
	echo "Will run:" l:Command
	call system(l:Command)
      else
	call delete(l:File)
      endif
    endif
  endfor
endfunction
" }}}

" }}}

" options {{{
" general {{{
" enable syntax processing
syntax enable

" show cursorline
set cursorline

" show command in progress
set showcmd

" eob chars are shown as spaces.
let &fillchars ..= ',eob: '

" enable mouse on all modes
set mouse=a

" do not wrap lines - let them go offscreen.
" set nowrap

" enable 'h' and 'l' keys to go to next line.
set whichwrap+=h,l

" enable '-' as keyword.
set iskeyword+=-
" }}}

" tabs: {{{
" Always keep 'tabstop' at 8, set 'softtabstop' and 'shiftwidth' to 2
" and use 'noexpandtab'.  Then Vim will use a mix of tabs and spaces,
" but typing <Tab> and <BS> will behave like a tab appears every 2 characters.
" This is the recommended way as per the manual, the file will look the same
" with other tools and when listing it in a terminal.

"set tabstop=8
set softtabstop=2
set shiftwidth=2
set noexpandtab

" load filetype-specific indent files
filetype plugin indent on
" }}}

" number column {{{
set number	     " Enable the line numbers on the left side of the lines.
set numberwidth=2    " Give the number column a smaller width. (default: 4)
set relativenumber   " Relative numbering to cursor.
set signcolumn=yes   " Always show the sign column.
" }}}

" searching {{{
set incsearch  " search as characters are entered
set hlsearch   " highlight matches
set ignorecase " ignore case
set smartcase  " do not ignore case if uppercase.
" }}}

" folding {{{
set foldlevelstart=10 " open most folds by default
set foldnestmax=10    " 10 nested fold max
set foldmethod=indent " fold based on indent level
" }}}

" backups {{{
" Turn on backup option
set backup

" Where to store backups
set backupdir=~/.vim/backups//

" Make backup before overwriting the current buffer
set writebackup

" Overwrite the original backup file
set backupcopy=yes

" No swap files
set noswapfile
" }}}
" }}}

" keymaps {{{

" leader key
let mapleader=","

if has('clipboard')
  vmap <C-c> "+yi
  vmap <C-x> "+c
  vmap <C-v> c<ESC>"+p
  imap <C-v> <C-r><C-o>+
endif

" toggle focused mode
nnoremap <leader>1 :Goyo<CR>

" toggle markdown preview
nnoremap <leader>m <Plug>MarkdownPreviewToggle

" toggle relative numbering
nnoremap <leader>r :call ToggleNumber()<CR>

" toggle fzf-mode
nnoremap <leader>g :GitFiles<CR>
nnoremap <leader>d :DesktopFiles<CR>

" format code by keybinding
nnoremap <leader>f :ALEFix<CR>

" stop searches when escape is pressed
nmap <esc> :noh<CR>

" consistent copy and paste
vnoremap p _dP

" stay in indent mode
vnoremap < <gv^
vnoremap > >gv^
" }}}

" autocmds {{{
" Set meaningful backup names
au BufWritePre * let &backupext = '~' . localtime()

" Remove old backups
au VimLeave * call <SID>DeleteOldBackups()
" }}}

" plugins {{{
" bootstrap vim-plug {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'

  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-endwise'
  Plug 'tomtom/tcomment_vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'easymotion/vim-easymotion'

  Plug 'michaeljsmith/vim-indent-object'

  Plug 'junegunn/fzf.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'Yggdroot/indentLine'
  Plug 'dense-analysis/ale'

  Plug 'sainnhe/gruvbox-material'

  Plug 'preservim/vim-markdown'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

  Plug 'preservim/vim-colors-pencil'
  Plug 'junegunn/goyo.vim'
call plug#end()
" }}}

" plugins: gruvbox-material {{{
" enable more colors
if has('termguicolors')
  set termguicolors
endif

" available values: 'dark', 'light'
set background=dark

" available values: 'hard', 'medium', 'soft'
let g:gruvbox_material_background = 'medium'

let g:gruvbox_material_better_performance = 1

colorscheme gruvbox-material
" }}}

" plugins: fzf-vim {{{
command! -bang DesktopFiles call fzf#vim#files('~/Desktop', <bang>0)
" }}}

" plugins: lightline {{{
set noshowmode " as lightline already does that

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'], ['filetype']],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" }}}

" plugins: goyo {{{
function! s:goyo_enter()
    set background=light
    colorscheme pencil
    set wrap
endfunction

function! s:goyo_leave()
    set background=dark
    colorscheme gruvbox-material
    set nowrap
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}}

" plugins: indentline {{{
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" }}}

" plugins: ale {{{
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort']
\}
" Set this variable to 1 to fix files when you save them.
" let g:ale_fix_on_save = 1
" }}}

" plugins : vim-markdown {{{
let g:vim_markdown_math = 1
let g:vim_markdown_no_extensions_in_markdown = 1
let g:tex_conceal = ""
let g:vim_markdown_conceal_code_blocks = 0
" }}}

