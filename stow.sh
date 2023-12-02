#!/usr/bin/env bash

stow --restow --target=$HOME xorg zsh \
	2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) # bugfix

mkdir -p $HOME/.scripts
stow --restow --target=$HOME/.scripts scripts

CONFIG_DOTFILES=(
	'i3'
	'sxhkd'

	'i3blocks'
	'picom'

	'alacritty'
	'rofi'
	'dunst'
	# 'nvim'

	'qutebrowser'
)

for dir in "$CONFIG_DOTFILES"; do
	target="$HOME/.config/$dir"

	if [ -d "$stow_pkg" ]; then
		mkdir -p "$target"
	fi

	stow --restow --target=$target $dir
done
