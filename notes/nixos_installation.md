1. Boot on a Nixos graphical installer ISO image

2. Go through the graphical installation process, select Plasma as a graphical desktop environment

3. Boot into the new system

4. Clone the repo

  ```bash
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes 'nixpkgs#git' -- clone https://github.com/glostis/dotnix
  ```

5. Refresh `hardware-configuration.nix` if needed:

  ```bash
  nixos-generate-config --show-hardware-config > ~/dotnix/nixos/hardware-configuration.nix
  ```

6. Rebuild with the new configuration

  ```bash
  sudo nixos-rebuild switch --flake /home/glostis/dotnix#suzanne
  ```

7. Reboot

  ```bash
  sudo reboot
  ```

8. Build the home-manager configuration

  ```bash
  nix run 'nixpkgs#home-manager' -- switch --flake ~/dotnix
  ```

9. Reboot

  ```bash
  sudo reboot
  ```
