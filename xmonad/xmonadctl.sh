#!/bin/sh

PROJECT="$HOME/.config/xmonad"

exec "$(cd "$PROJECT" && stack path --local-install-root)/bin/xmonadctl" "$@"
