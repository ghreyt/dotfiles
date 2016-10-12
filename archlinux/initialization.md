# Cheat sheet to configure Archlinux

## essential configurations

1. [Microcode](https://wiki.archlinux.org/index.php/Microcode)

## Configure

1. install frequently used packages

   ``` shell
   # TODO fill this
   $ pacman -S vim
   ```
1. install [pacaur](https://github.com/rmarquis/pacaur)
   [install-pacaur.sh](https://gist.github.com/rumpelsepp/d646750910be19332753)
1. install desktop enviroment

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
