#! /usr/bin/bash
# vim: ft=sh

# Dirty hack taken from https://stackoverflow.com/a/9522766
# to allow bash multiline command with comments
CMD=(
    yay -S --needed

    ## System
    base
    efibootmgr
    grub
    linux
    linux-firmware
    base-devel               # (group)
    xorg                     # (group)
    xclip                    # clipboard
    xdotool                  # xorg
    xf86-video-intel         # graphics
    xorg-xinit               # graphics
    openssh                  # ssh

    ## Programs
    alacritty                # Terminal
    google-chrome            # Browser (aur)
    qutebrowser              # Browser
    virtualbox               # VM
    google-earth-pro         # Google Earth (aur)
    zoom                     # Video conferencing (aur)
    arandr                   # GUI to xrandr, to configure monitors
    signal-desktop           # Messaging app
    vlc                      # Video viewer
    vpv                      # Image viewer (aur)
    redshift                 # Turns screen to red to avoid blue light
    libreoffice-fresh        # Bureautique
    bitwarden                # Password manager GUI
    gthumb                   # Quick photo editing
    gimp                     # Not-so-quick photo editing
    mupdf                    # pdf viewer

    ## Terminal programs
    bat                      # Fancy `cat`
    diff-so-fancy            # Fancy `diff`
    docker                   # Containers
    docker-compose           # Containers
    man-db                   # man
    man-pages                # man
    mlocate                  # `locate` command
    ncdu                     # Curses disk usage explorer
    git-lfs                  # Git Large File Storage
    chezmoi                  # Dotfiles manager
    expac                    # pacman database extraction utility
    feh                      # Background image setter
    fzf                      # Fuzzy finder
    htop                     # System resources monitoring
    imagemagick              # Image manipulation commands
    jq                       # JSON parser
    khal                     # Terminal-based calendar
    vdirsyncer               # Terminal-based calendar
    neofetch                 # System information
    neovim                   # Editor
    ranger                   # File browser
    tmux                     # Terminal multiplexer
    tree                     # Recursive directory listing
    unzip                    # Unarchiving
    zsh                      # Shell
    antibody                 # zsh plugin manager (aur)
    wget                     # File download
    reflector                # Sort pacman mirrors
    ripgrep                  # Fast recursive grep
    scrot                    # Screenshot
    pyenv                    # Python manager
    yay-bin                  # AUR helper (aur)
    fixjson                  # JSON formatter (aur)
    ctags                    # ctags
    bc                       # Command-line calculations
    w3m                      # Text-based web browser

    ## Hardware
    # Audio
    alsa-utils
    pamixer
    playerctl
    pulseaudio
    pulseaudio-alsa
    pulseaudio-bluetooth
    pavucontrol
    # Screen backlight
    light
    # Network
    networkmanager
    network-manager-applet
    bluez
    bluez-utils

    ## Window manager
    i3-gaps                  # WM
    dunst                    # Notifications dameon
    i3lock                   # Desktop locker
    corrupter-bin            # Script that "corrupts" an image for i3lock bg (aur)
    i3-battery-popup-git     # Send notification when battery is low (aur)
    autorandr                # Multi-monitor
    picom-ibhagwan-git       # Compositor (aur)
    rofi                     # Launcher
    unclutter                # Remove mouse cursor when idle
    xidlehook                # Trigger action after some time idle (aur)
    polybar-git              # Status bar (aur)
    touchpad-indicator-git   # Fix touchpad weirdness (aur)
    xplugd-git               # Execute action on device plug/unplug (aur)
    rofi-bluetooth-git       # Rofi front-end to bluetoothctl (aur)
    networkmanager-dmenu-git # Rofi front-end to networkmanager (aur)

    # Fonts
    gnu-free-fonts
    noto-fonts
    noto-fonts-emoji
    ttf-dejavu
    ttf-droid
    ttf-font-awesome
    ttf-inconsolata
    ttf-liberation
    ttf-roboto
    ttf-ubuntu-font-family
    terminus-font
    nerd-fonts-meslo        # (aur)
)

"${CMD[@]}"

CMD=(
    # The following packages are installed as optional dependencies of other packages
    yay -S --asdeps --needed
    python-requests-oauthlib # dep of vdirsyncer
    pdfjs                    # dep of qutebrowser
    python-pynvim            # dep of neovim
)

"${CMD[@]}"
