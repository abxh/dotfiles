# start xinit after zsh is started (when logged in)
# and save the xorg log to ~/.xorg.log

if [ "$(tty)" = "/dev/tty1" ]; then
    exec startx -- -keeptty > ~/.xorg.log 2>&1
fi
