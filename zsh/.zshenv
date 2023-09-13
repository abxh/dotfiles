export EDITOR=vim
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

eval "$(dircolors)"
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:' # highlight dirs without background.
export LS_COLORS

typeset -U path PATH
path=(~/.dotnet/tools ~/.local/bin $path)
export PATH

export QT_QPA_PLATFORMTHEME=gtk2

export ELECTRON_TRASH=trash-cli code
