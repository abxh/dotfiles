# dotfiles
## Notable ricing

Opinationed border and transparency logic:

![](./.images/window0.png)

![](./.images/window1.png)

Transparent bars with nice colors and blocklets:

![](./.images/i30.png)

Notifications:

![](./.images/notifs0.png)

![](./.images/notifs1.png)

![](./.images/notifs2.png)

And finally as of lately, a *proper* rice of rofi ;) :

![](./.images/rofi0.png)

![](./.images/rofi1.png)

> [This wallpaper](https://wallhaven.cc/w/j5p23m) is used in the previews.

## Intro
Hey there, :). Welcome to my dotfiles. 

If you wish to use my dotfiles, please note that the dotfiles are modified to suit my laptop, so some hardcoded things might not work as expected in other pcs.

With my dotfiles, I strive to achieve a certain level of elegance and beauty without using a lot of colors and keeping it look simple.

> **Note:** The following hyperlinks point to directories in this repo.

The window manager [i3](https://github.com/abxh/dotfiles/tree/main/i3/config) is used with [sxhkd](https://github.com/abxh/dotfiles/tree/main/sxhkd), which sets all the keybindings except modes.

The fancy blur effect and other effects comes from [picom](https://github.com/abxh/dotfiles/tree/main/picom/picom.conf).

The bar uses [i3bar](https://github.com/abxh/dotfiles/tree/main/i3/i3bar), [i3blocks](https://github.com/abxh/dotfiles/tree/main/i3blocks) and [scripts](https://github.com/abxh/dotfiles/tree/main/scripts/i3blocklets) to achieve it's magic.

Notifications are done through [dunst](https://github.com/abxh/dotfiles/tree/main/dunst) with [scripts](https://github.com/abxh/dotfiles/tree/main/scripts/dunstify).

Both the bar and notifications use icons from [my fork of the gruvbox-material-gtk theme](https://github.com/abxh/gruvbox-material-gtk) (with OneColored Icons).

A combination of [zsh](https://github.com/abxh/dotfiles/tree/main/zsh), [Alacritty](https://github.com/abxh/dotfiles/tree/main/alacritty) and vim
is used as the shell, terminal and editor.

And finally [qutebrowser](https://github.com/abxh/dotfiles/tree/main/qutebrowser) is used. It is a keyboard-driven browser with vim-like bindings.

### Tip
Submodules can be downloaded this way
```
git submodule init
git submodule update
```

## Tree view
```
.
├── .images
│   └── ...
├── alacritty
│   ├── alacritty.yml
│   └── gruvbox_material.yml
├── dunst
│   └── dunstrc
├── i3
│   ├── modes
│   │   ├── resize
│   │   └── system
│   ├── bar
│   └── config
├── i3blocks
│   ├── bottom
│   └── top
├── mpv
│   └── mpv.conf
├── picom
│   └── picom.conf
├── qutebrowser
│   ├── solarized-everything-css (submodule)
│   │   └── ...
│   ├── config.py
│   └── gruvbox.py
├── rofi
│   └── config.rasi
├── scripts
│   ├── dunstify
│   │   ├── dunstify_br
│   │   └── dunstify_vol
│   ├── i3blocklets
│   │   ├── battery2
│   │   ├── calendar
│   │   ├── count_updates
│   │   ├── focused_window_title
│   │   └── focused_window_title_update
│   ├── i3lock_launch
│   ├── sxhkd_restart
│   └── todo
├── sxhkd
│   ├── i3-keys
│   └── wm-independent-keys
├── xorg
│   ├── .Xresources
│   └── .xinitrc
├── zsh
│   ├── .zprofile
│   ├── .zshenv
│   └── .zshrc
├── .gitmodules
├── LICENSE
├── README.md
└── stow.sh

31 directories, 151 files
```
