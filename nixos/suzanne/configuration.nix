{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "suzanne";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.windowManager.i3.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # services.gnome.gnome-keyring = {
  #   enable = true;
  # };
  # programs.seahorse.enable = true;
  # # For gnome-keyring + i3: https://github.com/NixOS/nixpkgs/issues/174099
  # services.xserver.displayManager.sessionCommands = ''
  #   ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
  # '';

  # Create the uinput group
  users.groups.uinput = {};

  # For kmonad
  services.udev.extraRules =
    /*
    udevrules
    */
    ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

  users.users.glostis = {
    isNormalUser = true;
    description = "Guillaume";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      # For kmonad
      "input"
      "uinput"
    ];
    packages = with pkgs; [
      git
      neovim
      home-manager
    ];
  };

  users.users.lucie = {
    isNormalUser = true;
    description = "Lucie";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      google-chrome
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  programs.i3lock.enable = true;

  system.stateVersion = "24.05";
}
