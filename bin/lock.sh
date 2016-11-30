#!/usr/bin/env bash

NAME=$(basename $0)

if [[ $(pgrep -f $NAME) ]]; then
    echo '$0:already locked'
else
    /usr/bin/i3lock-fancy -g -p -f "Noto-Sans" -- maim
fi
