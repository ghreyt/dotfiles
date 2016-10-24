# Intel Graphics

[ArchWiki's intel graphics](https://wiki.archlinux.org/index.php/intel_graphics)

## installation

``` shell
# install packages for intel
$ pacaur -S xf86-video-intel mesa-libgl vulkan-intel
...
>>> This driver now uses DRI3 as the default Direct Rendering
    Infrastructure. You can try falling back to DRI2 if you run
    into trouble. To do so, save a file with the following 
    content as /etc/X11/xorg.conf.d/20-intel.conf :
      Section "Device"
        Identifier  "Intel Graphics"
        Driver      "intel"
        Option      "DRI" "2"             # DRI3 is now default 
        #Option      "AccelMethod"  "sna" # default
        #Option      "AccelMethod"  "uxa" # fallback
      EndSection
Optional dependencies for xf86-video-intel
    libxrandr: for intel-virtual-output [installed]
    libxinerama: for intel-virtual-output [installed]
    libxcursor: for intel-virtual-output [installed]
    libxtst: for intel-virtual-output [installed]
    libxss: for intel-virtual-output [installed]
...
```

## early KMS (Kernel Mode Setting)

[ArchWiki's Kernel mode setting - Early KMS start](https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start)

``` shell
# /etc/mkinitcpio.conf
MODULES="intel_agp i915"

# make initramfs
$ sudo mkinitcpio -p linux

# set options
# try to enable rc6pp sleep,
# my card seems not work though
# /etc/modprobe.d/i915.conf
options i915 enable_rc6=7
```
