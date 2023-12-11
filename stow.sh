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

	'kitty' # 'alacritty'
	'rofi'
	'dunst'
	# 'nvim'

	'qutebrowser'
	'zathura'
	'mpv'
)

for dir in "${CONFIG_DOTFILES[@]}"; do
	target="$HOME/.config/$dir"
	mkdir -p "$target"
	stow --restow --target=$target $dir
done
