#!/bin/bash

# stow script

# NOTE:
# please comment out all the packages and test them
# one by one to not break anything in your setup

stow-config-dotfiles() {
    for stow_pkg in "$@"; do
        target="$HOME/.config/$stow_pkg"

        if [ -d "$stow_pkg" ]; then
	    mkdir -p "$target"
        fi

        stow --restow --target=$target $stow_pkg
    done
}

stow --restow --target=$HOME xorg zsh

# NOTE:
# the script sxhkd_restart is important for the function of i3 keybindings
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
    \
    qutebrowser \
