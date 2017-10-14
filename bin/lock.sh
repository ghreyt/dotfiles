#!/usr/bin/env bash

#NAME=$(basename $0)
#PIDFILE=/var/run/lock.sh.pid
IMG=~/Dev/dotfiles/wallpaper/windows-10-wallpaper-11.png

#/usr/bin/i3lock-fancy -g -p -f "Noto-Sans" -- maim
/usr/bin/i3lock --show-failed-attempts --image=$IMG
