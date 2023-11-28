#! /bin/bash

if command -v makepkg &> /dev/null; then
    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yayrepo
        cd /tmp/yayrepo
        makepkg -si
        rm -r /tmp/yayrepo
    fi
fi
