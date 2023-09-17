# vim: foldmethod=marker foldlevel=0

# options {{{

# default directory
DEFAULT_DIR="~/Desktop"

# history file
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# emacs binding
bindkey -e

# theme
fpath+=($HOME/.zsh/lean)
autoload -U promptinit; promptinit
export PROMPT_LEAN_COLOR0='white' # prompt character
export PROMPT_LEAN_COLOR1='white' # jobs and VCS info indicator color
export PROMPT_LEAN_COLOR2='blue'  # dir
export PROMPT_LEAN_COLOR3='green' # elapsed time indicator color
prompt lean

# shell options. See 'man zsh-options' for more information.
# setopt autocd

# namespaced properties. See 'man zshmodules' for more information.
zstyle :compinstall filename '/home/arch/.zshrc'

# set custom title
autoload -Uz add-zsh-hook
function title_precmd () {
  print -Pn -- '\e]2;%#\a'
}

function title_preexec () {
  print -Pn -- '\e]2;%# ' && print -n -- "${(q)1}\a"
}

add-zsh-hook -Uz precmd title_precmd
add-zsh-hook -Uz preexec title_preexec

# autocompletion
autoload -Uz compinit
compinit

# autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c6c6c"
export ZSH_AUTOSUGGEST_STRATEGY="completion"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# history-substring-search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=magenta"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# }}}

# aliases {{{

alias cd="HOME=$DEFAULT_DIR cd"

# confirm before replacing
alias cp='cp -i'
alias mv='mv -i'

# trash-cli
alias rm='echo "Use dl instead."; false'
alias dl='trash-put'
alias dl-remove='trash-empty'
alias dl-list='trash-list'
alias dl-restore='trash-restore'

# ls variations
alias ls='ls --color=auto -hv --group-directories-first'
alias la='ls -lAG'
alias lst='tree -v --dirsfirst'
lsta() {
  # https://unix.stackexchange.com/a/691245
  rg --ignore --hidden --files --glob '!.git/' "$@" \
    | lst --fromfile -a
}

# find variations
alias find='fd'
alias f='cd $(fd --type directory --strip-cwd-prefix | fzf)'

# shiny colors
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias cat='bat --paging=never --theme=base16'
alias jq='jq --color-output'

# shorthands
alias get_wm_class="xprop | grep WM_CLASS"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias unixify="sed -i 's/\r//' filename"
alias fsharpi="dotnet fsi"

function pdf() {(zathura "$@" &;)}
function video() {(mpv "$@" &;)}
function image() {(imv "$@" &;)}

function git-clone() {
  author="$1"
  repo="$2"
  git clone git@github.com:$author/$repo.git
}

function asm() {
  f=$(basename "$1" .asm)
  nasm -f elf32 $f.asm -o $f.o
  [ $? -eq 0 ] && ld -m elf_i386 $f.o -o $f
}
alias dasm='objdump -d'
alias dasma='objdump -D'

function gccr() {
  f=$(basename "$1" .c)
  gcc "$f".c -o "$f"
}
function gcco() {
  f=$(basename "$1" .c)
  gcc "$f".c -O3 -march=native -ffast-math -o "$f"
}
function gccos() {
  f=$(basename "$1" .c)
  gcc "$f".c -O3 -march=native -o "$f"
}

# }}}

# keybindings {{{
# ^ for Ctrl.
bindkey '^g' clear-screen
bindkey -s '^v' ';vim $(fd --type f --strip-cwd-prefix -L | fzf)^M'
bindkey -s '^f' ';cd $(fd --type directory --strip-cwd-prefix -L | fzf)^M'
# }}}

# reset to $DEFAULT_DIR this way - because lf otherwise cds to $HOME when trying other directories.
[ "$(pwd)" = "$HOME" ] && cd
