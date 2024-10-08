# vim: foldmethod=marker

# options {{{

# default directory {{{
DEFAULT_DIR="$(xdg-user-dir DESKTOP)"
# }}}

# history file {{{
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# }}}

# emacs bindings {{{
bindkey -e
# }}}

# shell options. {{{
# See 'man zsh-options' for more information.
# setopt autocd
# }}}

# namespaced properties.{{{
# See 'man zshmodules' for more information.
zstyle :compinstall filename "$HOME/.zshrc"
# }}}

# set custom prompt {{{

setopt PROMPT_SUBST
autoload -U colors && colors
__blue='%{$fg[blue]%}'
__green='%{$fg[green]%}'
__reset_color='%{$reset_color%}'
__user='%m'
__percent_symbol='%%'
__git_branch () { b=$(git symbolic-ref --short HEAD 2> /dev/null); [ ! "$b" ] || echo "($b) "; }

__dir='%~'
PROMPT=$__green'$(__git_branch)'$__reset_color'${__user}''${__percent_symbol} '
RPROMPT=$__blue'${__dir}'$__reset_color
# }}}

# autocompletion {{{
autoload -Uz compinit
compinit
# }}}

# autosuggestions {{{
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c6c6c"
export ZSH_AUTOSUGGEST_STRATEGY="completion"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# }}}

# history-substring-search {{{
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=magenta"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# }}}
# }}}

# aliases {{{

alias cd="HOME=$DEFAULT_DIR cd"

# confirm before replacing
alias cp='cp -i'
alias mv='mv -i'

# shiny colors
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias cat='bat --paging=never --theme=base16'

# trash-cli
alias rm='echo "Use dl instead."; false'
alias dl='trash-put'
alias dl-remove='trash-empty'
alias dl-list='trash-list'
alias dl-restore='trash-restore'

# ls variations
alias ls='ls --color=auto -v --group-directories-first'
alias la='ls -lAGh'
alias lst='tree -v --dirsfirst'
alias lsta="lst -a --gitignore -I .git"

# handy shorthands
function pdf() {(zathura "$@" &;)}

# gcc variations
alias gcc='gcc -Wall -Wextra -Wshadow -Wconversion -pedantic -g -ggdb3'
alias gccs='gcc -fsanitize=address -fsanitize=undefined'\
  '-fno-sanitize-recover=all -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize=null -fno-sanitize=alignment'
alias gcco='/usr/bin/gcc -O3 -march=native'
alias gcc_preprocessed='/usr/bin/gcc -E "$@"'
alias gcc_compile='/usr/bin/gcc -S -masm=intel -fverbose-asm'
alias gcc_assemble='/usr/bin/gcc -c'

alias nasm_elf64='nasm -f elf64 -g'
alias objdump_intel='objdump -drwC -S -M intel'
# }}}

# keybindings {{{
# ctrl+g -> clear-screen
bindkey '^g' clear-screen
# ctrl+e -> find files and edit with vim
bindkey -s '^e' ';vim $(fd --type f --strip-cwd-prefix -L | fzf)^M'
# ctrl+f -> find dirs and cd to dir
bindkey -s '^f' ';cd $(fd --type directory --strip-cwd-prefix -L | fzf)^M'
# }}}

# reset to $DEFAULT_DIR
[ "$(pwd)" = "$HOME" ] && cd
