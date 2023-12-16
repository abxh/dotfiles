#!/usr/bin/env bash

echo "[status] fixing broken symlinks..."
find ~ -xtype l -print -delete | sed -e 's/^/[fixing] /;'

echo "[status] removing empty directories in ~/.config"
find ~/.config -empty -type d -print -delete | sed -e 's/^/[rmdir] /;'

echo "[status] running gnu stow..."
stow --restow --target=$HOME xorg zsh \
	2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) # bugfix

mkdir -p $HOME/.scripts
stow --restow --target=$HOME/.scripts scripts

CONFIG_DOTFILES=(
	'bspwm'
	'sxhkd'

	'polybar'
	'picom'

	'kitty'
	'rofi'
	'dunst'
	# 'nvim'

	'qutebrowser'
	'zathura'
	'mpv'
)

for dir in "${CONFIG_DOTFILES[@]}"; do
	target="$HOME/.config/$dir"
	if [ ! -d "$target" ]; then
		echo "[mkdir] $target"
		mkdir -p "$target"
	fi
	stow --restow --target=$target $dir
done
