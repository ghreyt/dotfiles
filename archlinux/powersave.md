# powersave

## install
``` shell
$ sudo pacman -S powertop
```

## enable powertop auto tune

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

## laptop\_mode

```
# /etc/sysctl.d/laptop.conf

vm.laptop_mode = 5
```


