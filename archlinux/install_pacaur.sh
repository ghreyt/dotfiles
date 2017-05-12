#!/usr/bin/env bash

export GNUPGHOME=/etc/pacman.d/gnupg

function install_pkg {
    local PKG=$1

    echo "*** install $PKG"
    git clone https://aur.archlinux.org/$PKG.git
    cd $PKG
    makepkg -sri
    cd -
}

# install cower first
install_pkg cower

# install pacaur
install_pkg pacaur

