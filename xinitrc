# load resource files
# - dotfiles repository must be cloned as ~/.dotfiles
# - load and merge all files named 'Xresources' under this directory
find ~/.dotfiles -name Xresources | xargs -I{} xrdb -merge -I$HOME {}

# start openbox alone
#exec openbox-session
