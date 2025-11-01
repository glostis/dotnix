{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}: let
  gtkTheme = "Gruvbox-Orange-${
    if ("${config.colorScheme.variant}" == "dark")
    then "Dark"
    else "Light"
  }-Compact";
  preferDark =
    if ("${config.colorScheme.variant}" == "dark")
    then true
    else false;

  # See https://github.com/nickclyde/rofi-bluetooth/pull/43
  patched-rofi-bluetooth = pkgs.rofi-bluetooth.overrideAttrs (previousAttrs: {
    patches = (previousAttrs.patches or []) ++ [./../patches/rofi-bluetooth.patch];
  });
in {
  imports = [
    ./keyboard.nix
    ./ghostty.nix
    ./dunst
    ./niri
    ./static
    ./bin
  ];

  home.packages = with pkgs; [
    ## Graphical applications

    # virtualbox                      # VM
    vlc # Video viewer
    libreoffice-fresh # Bureautique
    # bitwarden # Password manager GUI
    gthumb # Quick photo editing
    gimp # Not-so-quick photo editing
    mupdf # pdf viewer
    # spotify                         # Music streaming
    rhythmbox # Local music player
    # gparted # GUI for partioning disks and writing filesystems
    foliate # e-book reader
    calibre # e-book manager

    ## Window manager
    feh # Background image setter
    rofimoji # Provides an emoji picker using rofi
    haskellPackages.kmonad # Advanced keyboard configuration
    kalamine # Keyboard layout remapping tool
    android-file-transfer # Required to connect to Android phones through USB
    android-udev-rules # Dependency of android-file-transfer
    devour # Open a new program by hiding the current window
    exiftool # Read EXIF properties of images

    libnotify # Provides `notify-send`
    patched-rofi-bluetooth # Rofi front-end to bluetoothctl
    networkmanager_dmenu # Rofi front-end to networkmanager

    xdg-utils # Provides command-line tools such as `xdg-open`

    ## Hardware
    # Backlight
    brightnessctl
    # Audio
    pamixer
    playerctl
    pavucontrol
    # Network
    # Better handled by the host OS
    # networkmanager
    # networkmanagerapplet

    # The following are better handled by the host OS:
    # alsa-utils
    # pulseaudioFull
    # bluez
    # bluez-utils

    # Fonts
    freefont_ttf
    noto-fonts
    noto-fonts-color-emoji
    dejavu_fonts
    font-awesome
    inconsolata
    liberation_ttf
    roboto
    ubuntu_font_family
    terminus_font
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrainsMono NF"];
      sansSerif = ["Roboto"];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "${gtkTheme}";
      # Override to change the color of the theme
      package = pkgs.gruvbox-gtk-theme.overrideAttrs (previousAttrs: {
        version = "${previousAttrs.version}-patch-orange";
        __intentionallyOverridingVersion = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/themes
          cd themes
          ./install.sh -n Gruvbox --theme orange --size compact -d "$out/share/themes"
          runHook postInstall
        '';
      });
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=${toString preferDark}
    '';
    gtk3.extraConfig.gtk-application-prefer-dark-theme = preferDark;
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-${config.colorScheme.variant}";
    };
  };

  home.pointerCursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-${config.colorScheme.variant}";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  services.network-manager-applet.enable = false;

  programs.rofi = {
    enable = true;
    theme = "gruvbox-${config.colorScheme.variant}";
  };
}
