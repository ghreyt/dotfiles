#!/usr/bin/env bash

case $1 in
up)
    /usr/bin/amixer -q set Master 0.3dB+ unmute
    ;;
down)
    /usr/bin/amixer -q set Master 0.3dB- unmute
    ;;
mute)
    /usr/bin/amixer -q set Master toggle
    ;;
*)
    echo "invalid command:$1"
    ;;
esac

volume=$(/usr/bin/amixer get Master | tail -n1 | tr -d '[]' | awk '{print $6=="off" ? "mute":$4}')
notify-send.sh -r 2874819 -u low -a volume -t 1 "$volume"
