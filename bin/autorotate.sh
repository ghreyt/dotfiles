#!/usr/bin/env bash

#
# ## Prerequisites
#
# ### install necessary packages
#
# ```sh
# $ sudo apt install iio-sensor-proxy
# ```
#
# ### activate iio-sensor-proxy
#
# ```sh
# $ sudo systemctl start iio-sensor-proxy
# $ sudo systemctl enable iio-sensosr-proxy
# ```
#
# ## Notes
#
# ### output format of monitor-sensor
# ```
# ** Message: Accelerometer orientation changed: left-up
# ** Message: Accelerometer orientation changed: normal
# ```
#
# ### stdbuf
#
# set buffering off using stdbuf
#
# ### /var/tmp/autorotate.lastid
#
# simple way to share the last id of worker
#
# # transform touchapd and touchscreen
# http://wiki.ubuntu.com/X/InputCoordinateTransformation

TSCR='ELAN Touchscreen'
TPAD='DLL06FD:01 04F3:300F Touchpad'

LAST_ID_FILE=/var/tmp/autorotate.lastid

monitor-sensor 2>&1 | grep --line-buffered 'orientation' | stdbuf -oL -eL cut -d' ' -f6 |
while read orientation; do
    lastId=$((lastId + 1))
    echo $lastId > $LAST_ID_FILE

    {
        id=$lastId
        sleep 2
        lastId=$(cat $LAST_ID_FILE)

        # rotate only when current worker is still the last after 2 seconds
        if [[ $id == $lastId ]]; then
            echo "orientation changed: $orientation"
            case "$orientation" in
            # for Ubuntu
            # launcher can be moved via
            # gsettings set com.canonical.Unity.Launcher launcher-position Left/Bottom/Top/Right
            normal)
                xrandr --output eDP1 --rotate normal
                xinput set-prop "${TSCR}" 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
                xinput set-prop "${TPAD}" 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
                ;;
            bottom-up)
                xrandr --output eDP1 --rotate inverted
                xinput set-prop "${TSCR}" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
                xinput set-prop "${TPAD}" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
                ;;
            right-up)
                xrandr --output eDP1 --rotate right
                xinput set-prop "${TSCR}" 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
                xinput set-prop "${TPAD}" 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
                ;;
            left-up)
                xrandr --output eDP1 --rotate left
                xinput set-prop "${TSCR}" 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
                xinput set-prop "${TPAD}" 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
                ;;
            esac
        fi
    } & # run worker in background
done
