# configuration for i3lock (any variant)

## install

``` shell
$ pacaur -S i3lock-fancy

```

## copy to

``` shell
/etc/systemd/system/lock.suspend@.service
```

## enable service

``` shell
$ systemctl enable lock.suspend@yolongyi.service
```
