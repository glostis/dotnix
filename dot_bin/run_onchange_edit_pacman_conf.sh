#! /bin/bash
# vim:ft=bash

path="/etc/pacman.conf" 
if [ -f $path ]; then
    for param in Color VerbosePkgLists; do
        sudo sed -i "s/^#${param}/${param}/" $path
    done
fi
