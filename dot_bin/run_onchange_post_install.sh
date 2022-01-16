#! /bin/bash

chsh -s /bin/zsh

${HOME}/.bin/add_touchpad_conf
${HOME}/.bin/edit_pacman_conf
${HOME}/.bin/install_yay
${HOME}/.bin/install_archlinux

# Use `id $USER` to check to which groups the user currently belongs
sudo usermod -G docker,video $USER
