### Ubuntu Server installation

Not much to keep an eye for here: burn the ISO image to a USB device, boot, follow the installer.

### Nix installation

Install nix using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Clone dotnix
```
git clone https://github.com/glostis/dotnix.git ~/dotnix
```

### Home-manager installation and profile switch
```
rm -f ~/.profile ~/.bashrc
nix run --no-write-lock-file github:nix-community/home-manager -- --flake ~/dotnix switch
```

### `apt` installs
```bash
sudo apt update
sudo apt upgrade
sudo apt install --no-install-recommends \
    apt-file \
    bluez \
    cups \
    google-chrome-stable \
    gthumb \
    ncdu \
    network-manager \
    plocate \
    policykit-1-gnome \
    pulseaudio \
    wireplumber \
    libspa-0.2-bluetooth \
    libspa-0.2-libcamera \
    rhythmbox \
    sddm \
    swaylock \
    seahorse \
    vim \
    xdg-desktop-portal-gnome
sudo apt remove command-not-found
```

[Switch from netplan to NetworkManager](https://documentation.ubuntu.com/core/explanation/system-snaps/network-manager/how-to-guides/networkmanager-and-netplan/):
```
snap install network-manager
```

### Install Docker

## TODO list

### Problems

- Using systemd services on non-NixOS: [SO](https://unix.stackexchange.com/questions/349199/how-does-nix-manage-systemd-modules-on-a-non-nixos)

- Some graphical apps not working:

    - gparted : `The value for the SHELL variable was not found the /etc/shells file`

- (minor) All app icons don't show in `rofi`
