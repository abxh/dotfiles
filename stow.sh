#!/bin/bash

# stow script

# Warning:
# Do not use this script unless you know what you are doing. (Or learn it by testing it by dummy
# tests or your own configs).
#
# You might break your current configuration.

stow-config-dotfiles() {
    for stow_pkg in "$@"; do
        target="$HOME/.config/$stow_pkg"

        if [ -d "$stow_pkg" ]; then
	    mkdir -p "$target"
        fi

        stow --restow --target=$target $stow_pkg
    done
}

stow --restow --target=$HOME xorg zsh \
    2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) # this a fix to a bug i experience.

mkdir -p $HOME/.scripts
stow --restow --target=$HOME/.scripts scripts

stow-config-dotfiles \
    i3 sxhkd \
    \
    i3blocks \
    picom \
    \
    alacritty \
    rofi \
    dunst \
    nvim \
    \
    qutebrowser \
