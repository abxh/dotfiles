# vim: foldmethod=marker foldlevel=0

# options {{{

# default directory {{{
DEFAULT_DIR="~/desktop"
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
zstyle :compinstall filename '/home/arch/.zshrc'
# }}}

# set custom prompt {{{
__parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null
}

setopt PROMPT_SUBST
autoload -U colors && colors
__blue='%{$fg[blue]%}'
__green='%{$fg[green]%}'
__reset_color='%{$reset_color%}'
__user='%m'
__percent_symbol='%%'
__git_branch () { b=$(__parse_git_branch); [ ! "$b" ] || echo "($b) "; }
__dir='%~'
PROMPT=$__green'$(__git_branch)'$__reset_color'${__user}''${__percent_symbol} '
RPROMPT=$__blue'${__dir}'$__reset_color
# }}}

# set custom title {{{
autoload -Uz add-zsh-hook
function title_precmd () {
  print -Pn -- '\e]2;%#\a'
}

function title_preexec () {
  print -Pn -- '\e]2;%# ' && print -n -- "${(q)1}\a"
}

add-zsh-hook -Uz precmd title_precmd
add-zsh-hook -Uz preexec title_preexec
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
lsta() {
  # https://unix.stackexchange.com/a/691245
  rg --ignore --hidden --files --glob '!.git/' "$@" \
    | lst --fromfile -a
}

# handy shorthands
function image() {(imv "$@" &;)}
function video() {(mpv "$@" &;)}
function pdf() {(evince "$@" &;)}

function git-clone-ssh() {
  author="$1"
  repo="$2"
  git clone git@github.com:$author/$repo.git
}
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
