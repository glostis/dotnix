{pkgs, ...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4"];

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    glostis = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj00t57iGyCg3aR1o5/+X8qLrAEX/jMKtYJ9gyrJSU4jgdBSD+mM1RaoZlwOcc9EqbRk7MKMGsPTq8KvOP7/rZGlEzD5lJweShLHcgnI1ojofgUTXc3RzJwpIUDHPnOAMOBIy9X+1yIz0AXSU+UIWf2OLHINiLZS73p639iHl+lcmedhWR6bE1AVKfIe3FuHyvhGj0HOrwqZYXNdw0RH5c5Kbzhc4QTuOQuutypmXOatejDW1aO94Wz+uyRkkybHXYElJ+iN3vCsnvdxzOYVSiZB9ElTPCIBml6wUmojPfVCYhgYAAX3zEVmq8BjlUVnzcpLn9ceG4ICRd2O9riwjfslG9GzOFkHUnGDqT7nlJQUuP5fZ8T3MUyuHeYWLBxCmkSxc76M87ERSyXfmZsnZwYLGd4rUsYrjYpuyrdST5T9GrEoRNU2o0moKHSd4jRZ/w3ycTxcLAcS1GV+Dd1xXP8vx67apf+VwJdSYFp7/uXJhlGhFGm9hi25r3zS3JH1s= glostis@eugene"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;

  networking.hostName = "hector";
  networking.firewall = {
    allowedTCPPorts = [22];
    allowedUDPPorts = [12345];
  };

  system.stateVersion = "25.05";
}
