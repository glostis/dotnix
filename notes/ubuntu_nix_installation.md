### Ubuntu Server installation

Not much to keep an eye for here: burn the ISO image to a USB device, boot, follow the installer.

### `apt` installs

```bash
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:glostis/danklinux
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt upgrade
sudo apt install niri
sudo apt install --no-install-recommends \
    apt-file \
    google-chrome-stable \
    gthumb \
    ncdu \
    plocate \
    wireplumber \
    rhythmbox \
    swaylock
sudo apt remove command-not-found
```

```
# Already installed
    network-manager \
    bluez \
    cups \
    seahorse \
    vim \
    xdg-desktop-portal-gnome

# Not installed, but are they really necessary?
    policykit-1-gnome \
    pulseaudio \
    libspa-0.2-bluetooth \
    libspa-0.2-libcamera \
```

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

### Install Docker

## TODO list

### Problems

- Using systemd services on non-NixOS: [SO](https://unix.stackexchange.com/questions/349199/how-does-nix-manage-systemd-modules-on-a-non-nixos)

- Some graphical apps not working:

    - gparted : `The value for the SHELL variable was not found the /etc/shells file`
