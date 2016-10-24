# configuration for plymouth

## install

``` shell
$ pacaur -S plymouth plymouth-theme-arch-charge plymouth-theme-paw-arch
$ sudo systemctl disable lxdm.service
$ sudo systemctl enable lxdm-plymouth.service
```
## initramfs

``` 
$ sudo vi /etc/mkinitcpio.conf
HOOKS="base udev plymouth ..."

# set theme and update initramfs
$ sudo plymouth-set-default-theme -R arch-charge
```

## /boot/EFI/refind/refind.conf

```
options "... quiet splash ..."
```
