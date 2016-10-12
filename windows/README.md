# install Windows10

## download image

it contains both Windows 10 Home and Pro

- [Windows10 disk image downlaod](https://www.microsoft.com/ko-kr/software-download/windows10ISO)

## make bootable usb

### using Bootcamp Assistant

this worked

- [using Bootcamp Assistant](http://www.windowscentral.com/how-create-windows-10-installer-usb-drive-mac)

### using dd

this seems not work with my Dell Inspiron 13 7359

``` shell
$ diskutil list
$ diskutil unmountDisk /dev/disk2
$ sudo dd if=~/Download/Windows10.iso of=/dev/disk2 bs=1m
$ diskutil eject /dev/disk2
```

## install

### manual partition

- [UEFI/GPT partition layout](https://msdn.microsoft.com/ko-kr/library/windows/hardware/dn898510.aspx)

1. copy **create-partitions-uefi.txt** into install USB
1. boot with USB
1. shift+f10 to open terminal
1. run script or partition manually

    ``` shell
    > DiskPart /s F:\create-partitions-uefi.txt
    ```
