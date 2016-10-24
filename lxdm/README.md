# configuration for LXDM

## installation

``` shell
$ pacaur -S lxdm
$ systemctl enable lxdm.service
```

## theme

There are some themes in [AUR](https://aur.archlinux.org/packages/?O=0&K=lxdm)
but the [lxdm-mono-dark](https://github.com/aureooms/lxdm-mono-dark) is favourite.

``` shell
$ curl -LO https://github.com/aureooms/lxdm-mono-dark/archive/master.zip
$ unizp master.zip

# do not 'sudo make install' stated in github page
# which will overwrite /etc/lxdm/lxdm.conf
$ sudo cp -r lxdm-mono-dark-master/theme /usr/share/lxdm/themes/mono-dark
```

**and really recommend to change font !!!**

```
# /usr/share/lxdm/themes/mono-dark/gtkrc

font_name="Noto Sans 12"
```

## configuration

### simply

``` shell
$ sudo cp lxdm.conf /etc/lxdm/
```

### manually

``` shell
$ sudo vim /etc/lxdm/lxdm.conf

...
# set default session as openbox
session=/usr/bin/openbox-session
# set theme
theme=mono-dark
...
```

