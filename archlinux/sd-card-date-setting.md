# to get correct date and time for files in sd card

### from Archinux forum

- https://bbs.archlinux.org/viewtopic.php?id=186401

Hello, imrehg!
I solved this issue by creating mount.vfat helper that calculates current timezone offset:

```
#!/usr/bin/env bash
mount -itvfat -oiocharset=utf8,time_offset=$((`date +%:z|sed -r 's/^(.)0?(.*):0?/\1\2*60\1/'`)) "$@"
```

It might help you too.
UPD: I forgot to mention: this script must be saved as executable /usr/bin/mount.vfat

