# vim: foldmethod=marker

# gnu-utils with colors: {{{
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

eval "$(dircolors)"
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:' # highlight dirs without background.
export LS_COLORS
# }}}

# append extra paths in PATH variable:
typeset -U path PATH
path=(
  ~/.local/bin
  $path
)
export PATH

# default editor
export EDITOR=nvim
