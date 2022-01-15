#! /bin/bash

chsh -s /bin/zsh

# Use `id $USER` to check to which groups the user currently belongs
sudo usermod -G docker,video $USER
