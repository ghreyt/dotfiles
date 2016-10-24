# Cheat sheet to install Archlinux

This is personal notes to install and configure **Archlinux** (or any other
distro based on it) so do not expect it fit into everyone.

## Install

### make bootable installation USB

1. download ISO from [Arch Linux Downloads](https://www.archlinux.org/download/)
   - [Kaist mirror](http://ftp.kaist.ac.kr/ArchLinux/iso/latest/)
     - choose a file `archlinux-YYYY.MM.DD-dual.iso`
1. burn ([USB flash installation media](https://wiki.archlinux.org/index.php/USB_flash_installation_media))
    - using **dd** in Linux

        ``` shell
        $ dd bs=4M if=archlinux-YYYY.MM.DD-dual.iso of=/dev/sdx status=progress && sync
        ```

    - using **rufus** in Windows  
      when `dd` does not work for some UEFI boot like `DELL 7359 2-in-1 Laptop`

### install Archlinux
- references
  - [Installation guide](https://wiki.archlinux.org/index.php/Installation_guide)
  - [Partitioning](https://wiki.archlinux.org/index.php/Partitioning)

1. boot with USB
   - check boot mode, UEFI mode if directory exists, otherwise BIOS mode
    
     ``` shell
     $ ls /sys/firmware/efi/efivars
     ```
   - connect WIFI

     ``` shell
     $ wifi-menu
     ```
   - update the system clock

     ``` shell
     $ timedatectl set-ntp true
     ```
1. prepare the disk
   - partition disk, [GNU parted](https://wiki.archlinux.org/index.php/GNU_Parted)  
     just single root partition (with a swap file later)

     ``` shell
     # get disk path
     $ lsblk

     # run parted
     $ parted /dev/sda

     # in parted
     (parted) unit MiB print
     # make partition from the first unused byte to the end of disk
     (parted) mkpart primary ext4 73197MiB 100%
     (parted) print # check layout
     (parted) q # quit
     ```
   - format disk 

     ``` shell
     # get partition path
     $ lsblk
     $ mkfs.ext4 /dev/sdaX
     ```
   - mount file system
   
     ``` shell
     $ mount /dev/sdXY /mnt
     $ mkdir /mnt/boot
     $ mount /dev/sdXY /mnt/boot
     ```
1. select mirror
   - edit the file `/etc/pacman.d/mirrorlist`  
     put prefered mirror first
1. install Arch
   ``` shell
   # install Arch
   $ pacstrap /mnt base base-devel
   
   # make fstab
   $ genfstab -U /mnt >> /mnt/etc/fstab
   
   # get into new Arch chroot environment
   $ arch-chroot /mnt

   # timezone
   $ ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
   $ hwclock --systohc

   # install packages really needed during next steps or after reboot
   $ pacman -S vim \ # otherwise only vi
               dialog wpa_supplicant # to use wifi-menu (GUI for netctl)
               

   # locale
   $ vim /etc/locale.gen
   # uncomment en_US.UTF-8 and ko_KR.UTF-8
   $ locale-gen
   $ vim /etc/locale.conf
   # LANG=en_US.UTF-8
   
   # hostname
   $ vim /etc/hostname
   # myhostname
   $ vim /etc/hosts
   # 127.0.0.1 myhostname.localdomain myhostname
   
   # set root password
   $ passwd
   ```
1. install rEFInd ([Archwiki](https://wiki.archlinux.org/index.php/rEFInd))
   ``` shell
   $ pacman -S refind-efi

   # without Secure Boot
   $ refind-install

   # with Secure Boot enabled
   # get signed PreLoader.efi and HashTool.efi
   # https://wiki.archlinux.org/index.php/Secure_Boot#Set_up_PreLoader
   # http://blog.hansenpartnership.com/linux-foundation-secure-boot-system-released/
   $ curl -O http://blog.hansenpartnership.com/wp-uploads/2013/PreLoader.efi
   $ curl -O http://blog.hansenpartnership.com/wp-uploads/2013/HashTool.efi
   $ refind-install --preloader ./Preloader.efi
   ```
1. reboot
   ``` shell
   # exit chroot environment and reboot
   $ exit
   $ reboot
   ```
