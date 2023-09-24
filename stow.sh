#!/bin/sh

# Run this from home dir if the symlinks break
# find . -xtype l -delete

# symlink stuff using stow
stow --target=$HOME --restow \
	zsh   \
	xorg  \
	#vim   \

# stow packages (collections of dotfiles). not distro packages.
config_pkgs=(
	"i3"
	"i3blocks"
	"sxhkd"
	"picom"
	"alacritty"
	"rofi"
	"betterlockscreen"
	"mpv"
	"dunst"
	"lf"
	"qutebrowser"
	"zathura"
	#"mpd"
	#"ncmpcpp"
)

for pkg_name in ${config_pkgs[@]}; do
	[ ! -d "$pkg_name" ] && echo "package '$pkg_name' does not exist" && exit 1
	dir=$HOME/.config/$pkg_name
	mkdir -p $dir
	stow --target=$dir --restow $pkg_name
done

mkdir -p $HOME/.scripts
stow --target=$HOME/.scripts --restow "scripts"
