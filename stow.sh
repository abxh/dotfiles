#!/bin/bash

# Use stow to symlink config files.

# Run this from home directory, if the symlinks break:
# find . -xtype l -delete

scripts_dotfiles=0 # 0 for true, 1 for false.

dotfiles_in_home=(
    "zsh"
    "xorg"
)

dotfiles_in_config=(
    "i3"
    "sxhkd"

    "i3blocks"
    "alacritty"
    "rofi"
    "picom"
    "dunst"

    "qutebrowser"

    "nvim"

    "mpv"
)


# execution part {{{

check_if_dir_exists() {
    [ ! -d "$1" ] && echo "directory './$1' does not exist" >&2 && return 1 || return 0
}

if [ $scripts_dotfiles -eq 0 ]; then
    mkdir -p $HOME/.scripts
    stow --target=$HOME/.scripts --restow "scripts"
fi

for df in ${dotfiles_in_home[@]}; do
    $(check_if_dir_exists $df) || continue
    stow --target=$HOME --restow $df
done

for df in ${dotfiles_in_config[@]}; do
	check_if_dir_exists $df
	dir=$HOME/.config/$df
	mkdir -p $dir
	stow --target=$dir --restow $df
done
# }}}

# vim: foldmethod=marker foldlevel=0
