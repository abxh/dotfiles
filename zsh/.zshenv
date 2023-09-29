# vim: foldmethod=marker foldlevel=0

# append extra paths in PATH variable:
typeset -U path PATH
path=(
	~/.dotnet/tools
	~/.local/bin
	$path
)
export PATH

# default editor
export EDITOR=nvim

# trash-cli integration with vscode:
export ELECTRON_TRASH=trash-cli code

# gnu-utils with colors: {{{
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

eval "$(dircolors)"
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:' # highlight dirs without background.
export LS_COLORS
# }}}
