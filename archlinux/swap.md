# making swap

## swap file

``` shell
# create swap file
$ fallocate -l 8192M /swap
$ chmod 600 /swap
$ mkswap /swap
Setting up swapspace version 1, size = 8 GiB (8589930496 bytes)
no label, UUID=aa8c77fb-74be-4808-b637-a27479b46e4f
$ swapon /swap

# /etc/fstab
/swap	none	swap	default 	0 0
```

## set swappiness

``` shell
# /etc/sysctl.d/99-sysctl.conf
vm.swappiness=10
```
