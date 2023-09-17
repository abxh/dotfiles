#!/bin/sh

# symlink stuff using stow
stow --target=$HOME --restow \
	zsh   \
	vim   \
	xorg  \

# stow packages. not arch packages.
config_pkgs=(
	"i3"
	"i3blocks"
	"sxhkd"
	"picom"
	"alacritty"
	"rofi"
	"betterlockscreen"
	"mpv"
	"mpd"
	"ncmpcpp"
	"dunst"
	"lf"
	"qutebrowser"
	"zathura"
)

for pkg_name in ${config_pkgs[@]}; do
	[ ! -d "$pkg_name" ] && echo "package '$pkg_name' does not exist" && exit 1
	dir=$HOME/.config/$pkg_name
	mkdir -p $dir
	stow --target=$dir --restow $pkg_name
done

mkdir -p $HOME/.scripts
stow --target=$HOME/.scripts --restow "scripts"
