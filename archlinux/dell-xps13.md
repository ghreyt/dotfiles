# Dell XPS 13

## sound card pops (cracking) sound and noise

- *High noise floor when using headphones* in [Arch Wiki for Dell XPS 13(9350)](https://wiki.archlinux.org/index.php/Dell_XPS_13_(9350))
- set 22 for headset volume (3rd level from the left) in `alsamixer`
- no overriden every reboot
  - comment out '[Element Headphone Mic Boost]'  
    from `/usr/share/pulseaudio/alsa-mixer/paths/{analog-input-headphone-mic.conf,analog-input-internal-mic.conf}`
  - this will disable internal microphone
