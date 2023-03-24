#! /bin/bash

set -e

sudo pacman -S zsh
chsh -s /bin/zsh

${HOME}/.bin/add_touchpad_conf
${HOME}/.bin/add_wifi_wired_exclusive
${HOME}/.bin/edit_pacman_conf
${HOME}/.bin/deactivate_bluetooth_autoenable
${HOME}/.bin/install_yay
${HOME}/.bin/install_archlinux

# Use `id $USER` to check to which groups the user currently belongs
sudo usermod -aG docker,video $USER
