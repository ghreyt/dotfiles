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


```
# /etc/sysctl.d/99-sysctl.conf
# powersave
vm.dirty_writeback_centisecs = 1500
kernel.nmi_watchdog = 0
vm.laptop_mode = 5

# /etc/modprobe.d/powersave.conf
# powersave for audio
options snd_hda_intel power_save=1

# /etc/udev/rules.d/70-powersave.rules
# disable wake on lan
ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/usr/bin/ethtool -s %k wol d"

# sata active power management
ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"

# pci
ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

# i2c
ACTION=="add", SUBSYSTEM=="i2c", ATTR{power/control}="auto"

# usb
# whitelist
# a. ST_SENSOR_HUB
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{idVendor}=="0483", ATTR{idProduct}=="91d1", ATTR{power/control}="auto"
# b. touchpad
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{idVendor}=="04f3", ATTR{idProduct}=="228a", ATTR{power/control}="auto"
```


## History

```
$ powertop --html=powerreport.html
Loaded 0 prior measurements
Cannot load from file /var/cache/powertop/saved_parameters.powertop
File will be loaded after taking minimum number of measurement(s) with battery only 
RAPL device for cpu 0
RAPL Using PowerCap Sysfs : Domain Mask f
RAPL device for cpu 0
RAPL Using PowerCap Sysfs : Domain Mask f
RAPL device for cpu 0
RAPL Using PowerCap Sysfs : Domain Mask f
Devfreq not enabled
Cannot load from file /var/cache/powertop/saved_parameters.powertop
File will be loaded after taking minimum number of measurement(s) with battery only 
Preparing to take measurements
  unknown op '{'
Taking 1 measurement(s) for a duration of 20 second(s) each.
PowerTOP outputing using base filename powerreport.html
 
$ awk -F '</?td ?>' '/tune/ { print $4 }' powerreport.html

 echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'; 
 echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy'; 
 echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy'; 
 echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'; 
 echo '0' > '/proc/sys/kernel/nmi_watchdog'; 
 echo 'auto' > '/sys/bus/i2c/devices/i2c-2/device/power/control'; 
 echo 'auto' > '/sys/bus/i2c/devices/i2c-0/device/power/control'; 
 echo 'auto' > '/sys/bus/i2c/devices/i2c-1/device/power/control'; 
 echo 'auto' > '/sys/bus/usb/devices/1-4/power/control'; 
 echo 'auto' > '/sys/bus/usb/devices/1-7/power/control'; 
 echo 'auto' > '/sys/bus/usb/devices/1-8/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:04.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:16.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.2/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.3/power/control'; 
 echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/power/control';
```
