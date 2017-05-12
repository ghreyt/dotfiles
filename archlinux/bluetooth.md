# Bluetooth

```
# by root

# 1. enable bluetooth service

$ systemctl enable bluetooth.service
$ systemctl start bluetooth.service

# 2. set A2DP profile

# bad sound quality because profile is HSF/HFP
# instead of A2DP which is high quality for listening to music
# follow https://wiki.archlinux.org/index.php/Bluetooth_headset#A2DP_not_working_with_PulseAudio

$ sudo -ugdm vim /var/lib/gdm/.config/pulse/client.conf
autospawn = no
daemon-binary = /bin/true

$ sudo -ugdm mkdir -p /var/lib/gdm/.config/systemd/user
$ sudo -ugdm ln -s /dev/null /var/lib/gdm/.config/systemd/user/pulseaudio.socket
```
