
# zsh startup script

# start xinit after zsh is started i.e. when logged in
# and save log to ~/.xorg.log

if [ "$(tty)" = "/dev/tty1" ]; then
    exec startx -- -keeptty > ~/.xorg.log 2>&1
fi
