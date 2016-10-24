# configuration for sound

## disable pc speaker
``` shell
# /etc/modprobe.d/nobeep.conf
# disable pc speaker
blacklist pcspkr
```

## ALSA
ALSA is sound driver already installed and activated by udev auto
recognization. Simply **unmute [Master](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#Unmuting_the_channels) if no sound**.

``` shell
# amixer, alsamixer, aplay and etc
$ pacaur -S alsa-utils

# check alsa loaded
$ aplay -l

# unmute Master
$ amixer sset Master unmute
```

## applet in sys tray

``` shell
$ pacaur -S pnmixer
```
