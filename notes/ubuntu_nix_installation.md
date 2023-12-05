### Ubuntu Server installation

Not much to keep an eye for here: burn the ISO image to a USB device, boot, follow the installer.

### Nix installation

Install nix using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Chezmoi installation and application
```
nix run "nixpkgs#chezmoi" --source ~/dotfiles init glostis --branch nix
nix run "nixpkgs#chezmoi" --source ~/dotfiles apply
```

### Home-manager installation and profile switch
```
nix run --no-write-lock-file github:nix-community/home-manager -- --flake ~/dotfiles switch
```

### Remove snap from Ubuntu
[Link1](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-10-and-20-04-lts/)
[Link2](https://askubuntu.com/questions/1035915/how-to-remove-snap-from-ubuntu/1114686#1114686)
- Check that no snaps installed with `snap list`
```bash
sudo snap remove lxd
sudo snap remove core20
sudo snap remove snapd
sudo rm -rf /var/cache/snapd/
sudo apt autoremove --purge snapd gnome-software-plugin-snap
rm -fr ~/snap
sudo apt-mark hold snapd
```

### `apt` installs
```bash
sudo apt update
sudo add-apt-repository ppa:aslatter/ppa  # for alacritty
sudo apt upgrade
sudo apt install \
    xorg \
    plocate \
    alacritty \
    apt-file \
    pulseaudio \
    bluez \
    picom
sudo apt remove command-not-found xdg-desktop-portal
```
*Note: `xdg-desktop-portal` is removed due to [creating slow startup issues of applications like Firefox](https://github.com/flatpak/xdg-desktop-portal/issues/1032)*

## TODO list

### Problems

- Run binary as sudo: https://github.com/NixOS/nix/issues/6038

- Using systemd services on non-NixOS: [SO](https://unix.stackexchange.com/questions/349199/how-does-nix-manage-systemd-modules-on-a-non-nixos)

- Some graphical apps not working:

    - gparted : `The value for the SHELL variable was not found the /etc/shells file`

- docker: cf systemd services

- lightdm doesn't kick in

- (minor) All app icons don't show in `rofi`

### Nice to haves

- Use NixGL to wrap apps that need it:
    - gthumb
    - Alacritty
    - mupdf
    - Firefox?
    - picom?
```bash
nix shell --override-input nixpkgs np 'github:guibou/nixGL#nixGLIntel'
```