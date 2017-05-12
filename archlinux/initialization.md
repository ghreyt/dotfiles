# Cheat sheet to configure Archlinux

## essential configurations

1. [Microcode](https://wiki.archlinux.org/index.php/Microcode)

    ``` shell
    $ pacman -S intel-ucode
    ```

## Configure

1. install frequently used packages

   ``` shell
   # TODO fill this
   $ pacman -S vim
   ```
1. install [pacaur](https://github.com/rmarquis/pacaur)
   [install-pacaur.sh](https://gist.github.com/rumpelsepp/d646750910be19332753)
1. install desktop enviroment

## desktop environment

``` shell
$ pacaur -S openbox lxdm tint2 compton rxvt-unicode dunst oblogout obconf lxappearance lxappearance-obconf lxrandr lxinpu pcmanfm \
rofi
network-manager-applet
gnome-keyring # otherwise no password prompt
feh
xautolock
ibus
ibus-hangul
noto-fonts-cjk
unzip
openssh
alsa-utils
smplayer
smplayer-skins
smplayer-themes
smtube
pnmixer

# screenshot
maim
slop

# aur
            skippy-xd-git i3lock-fancy-git notify-send.sh
caffeine-ng
xorg-xbacklight

thunar
tumbler
thunar-media-tags-plugin
thunar-archive-plugin
ffmpegthumbnailer: for video thumbnails
poppler-glib: for PDF thumbnails
libgsf: for ODF thumbnails
libopenraw: for RAW thumbnail

xdg-user-dirs
# run xdg-user-dirs-update to create user directories

```

## powersave

### install
``` shell
$ sudo pacman -S powertop
```

### enable powertop auto tune

```
# /etc/systemd/system/powertop.service

[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
```

``` shell
$ systemctl enable powertop.service
```

### laptop\_mode

```
# /etc/sysctl.d/laptop.conf

vm.laptop_mode = 5
```



## more
```
xorg-xinput
```
