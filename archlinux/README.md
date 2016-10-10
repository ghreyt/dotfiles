# Cheat sheet to install and configure Archlinux

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
     # TODO fill this
     ```
   - format disk 

     ``` shell
     $ mkfs.ext4 /dev/sdXY
     ```
   - mount file system
   
     ``` shell
     $ mount /dev/sdXY /mnt
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
   
   # set root password
   $ passwd
   ```
1. install rEFInd ([Archwiki](https://wiki.archlinux.org/index.php/rEFInd))
   ``` shell
   $ pacman -S refind-efi
   $ refind-install
   ```
1. reboot
   ``` shell
   # exit chroot environment and reboot
   $ exit
   $ restart
   ```


## Configure

1. install frequently used packages
   ``` shell
   # TODO fill this
   $ pacman -S vim
   ```
1. [pacaur](https://github.com/rmarquis/pacaur)
   [pacaur_install.sh](https://gist.githubusercontent.com/Tadly/0e65d30f279a34c33e9b/raw/b3b5595a262c0633da1025c29757bbdd81b715cd/pacaur_install.sh)
1. lxdm
   ``` shell
   $ sudo pacman -S lxdm
   $ yaourt -S archlinux-lxdm-theme
   # or very simple theme
   # https://github.com/aureooms/lxdm-mono-dark
   
   # edit /etc/lxdm/lxdm.conf
   # - choose theme
   # - choose default session if put no bottom-panel
   
   $ sudo systemctl enable lxdm
   #$ sudo systemctl enable lxdm-plymouth
   ```
1. desktop enviroment
   - no specific DE, just install what I need

   ``` shell
   $ sudo pacman -S obconf pcmanfm feh lxrandr lxtask lxappearance lxappearance-obconf rxvt-unicode 
   ```
1. theme TODO
   - Numix
   - Numix Circle icon



end
