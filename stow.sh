#!/usr/bin/env bash

if [ "$1" = "-c" ]; then
	echo "[status] fixing broken symlinks..."
	find ~ -xtype l -print -delete | sed -e 's/^/[fixing] /;'

	echo "[status] removing empty directories in ~/.config"
	find ~/.config -empty -type d -print -delete | sed -e 's/^/[rmdir] /;'
fi

echo "[status] running gnu stow..."

HOME_DOTFILES=(
	'xorg'
	# 'xinit-bspwm'
	'xinit-i3wm'
	'zsh'
)

for dir in "${HOME_DOTFILES[@]}"; do
	stow --restow --target=$HOME $dir \
		2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) # bugfix
done

mkdir -p $HOME/.scripts
stow --restow --target=$HOME/.scripts scripts

CONFIG_DOTFILES=(
	'i3'

	# 'bspwm'
	# 'sxhkd-bspwm'

	'rofi'
	'picom'
	'dunst'
	'polybar'

	'alacritty'
	# 'kitty'
	# 'nvim'

	# 'qutebrowser'
	# 'zathura'
	# 'mpv'
)

for dir in "${CONFIG_DOTFILES[@]}"; do
	# strip -i3wm|-bspwm endings
	dir_new="${dir%-i3wm}"
	dir_new="${dir_new%-bspwm}"

	target="$HOME/.config/$dir_new"
	if [ ! -d "$target" ]; then
		echo "[mkdir] $target"
		mkdir -p "$target"
	fi
	stow --restow --target=$target $dir
done
