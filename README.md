# dotfiles
These are my personal dotfiles. As such, a lot of the configuration are tinkered for
my use and liking. Feel free to copy the stuff you like and understand, and leave the rest.

Use `stow.sh` after testing `stow` out. It's a wonderful program in managing dotfiles.

Special dependencies are written within the files themselves. Most dependencies should be inferrable
(or throw errors if missing). Preferably take chunks of configuration at a time, instead of copying
entire files.

I use [this](https://github.com/abxh/gruvbox-material-gtk) icon theme in the screenshots and in my dunstify
scripts as default. You can find `JetBrainsMono Nerd Font` from [here](https://github.com/ryanoasis/nerd-fonts/releases)
and `Font Awesome 6 Free` from [here](https://fontawesome.com/download). Use the aforementioned links, if
you cannot find them using your package manager, and copy them to `~/.local/share/fonts` and do `fccache`.

To clone this repo with the submodules, run:
```bash
git clone --depth=1 --recurse-submodules https://github.com/abxh/dotfiles
```

## Preview
<img src="https://i.redd.it/7jgwgkpamhdd1.png" />

The used wallpaper can be found [here](https://w.wallhaven.cc/full/pk/wallhaven-pkp1vp.png).
