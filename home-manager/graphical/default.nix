{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}: let
  gtkTheme = "Gruvbox-${
    if ("${config.colorScheme.variant}" == "dark")
    then "Dark"
    else "Light"
  }-BL";
  preferDark =
    if ("${config.colorScheme.variant}" == "dark")
    then true
    else false;

  # Taken from https://github.com/PassiveLemon/lemonix/blob/fa5b9a2765ae180db717650a43c26d964020c221/pkgs/corrupter/default.nix
  # because not (yet?) packaged in nixpkgs
  corrupter = pkgs.buildGoModule rec {
    pname = "corrupter";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "r00tman";
      repo = "corrupter";
      # Upstream does provide a release but it cannot be built due to missing go.mod. This commit has it. https://github.com/r00tman/corrupter/issues/15
      rev = "d7aecbb8b622a2c6fafe7baea5f718b46155be15";
      sha256 = "sha256-GEia3wZqI/j7/dpBbL1SQLkOXZqEwanKGM4wY9nLIqE=";
    };

    vendorHash = null;

    meta = with lib; {
      description = "Simple image glitcher";
      homepage = "https://github.com/r00tman/corrupter";
      license = licenses.bsd2;
      maintainers = with maintainers; [PassiveLemon];
      platforms = ["x86_64-linux"];
    };
  };
in {
  imports = [
    ./alacritty.nix
    ./dunst
    ./sxhkd
  ];

  home.packages = with pkgs; [
    ## Graphical applications

    # virtualbox                      # VM
    arandr # GUI to xrandr, to configure monitors
    vlc # Video viewer
    redshift # Turns screen to red to avoid blue light
    libreoffice-fresh # Bureautique
    bitwarden # Password manager GUI
    gthumb # Quick photo editing
    gimp # Not-so-quick photo editing
    mupdf # pdf viewer
    # spotify                         # Music streaming (aur)
    rhythmbox # Local music player
    # gparted # GUI for partioning disks and writing filesystems
    foliate # e-book reader

    ## Window manager
    feh # Background image setter
    maim # Screenshot
    rofi-screenshot # Take screencaptures (.mp4 or .gif) (aur)
    rofimoji # Provides an emoji picker using rofi
    haskellPackages.greenclip # Rofi-based clipboard manager (aur)
    # Temporarily disable due to build issues
    # haskellPackages.kmonad # Advanced keyboard configuration (aur)
    android-file-transfer # Required to connect to Android phones through USB
    android-udev-rules # Dependency of android-file-transfer
    devour # Open a new program by hiding the current window (aur)

    i3 # WM
    libnotify # Provides `notify-send`
    corrupter # Script that "corrupts" an image for i3lock bg (aur)
    unclutter-xfixes # Remove mouse cursor when idle
    xidlehook # Trigger action after some time idle (aur)
    # polybarFull comes with i3 support
    # This could also be done with just `polybar` with an override to add `i3Support = true;`,
    # but then polybar gets compiled locally which is a bit of a pain.
    polybarFull # Status bar
    xplugd # Execute action on device plug/unplug (aur)
    rofi-bluetooth # Rofi front-end to bluetoothctl (aur)
    networkmanager_dmenu # Rofi front-end to networkmanager (aur)

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
    meslo-lgs-nf

    # OpenGL on non-NixOS
    nixgl.nixGLIntel
  ];

  fonts.fontconfig.enable = true;

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = null;
      extraConfig = builtins.readFile ./i3/config;
    };
    initExtra = ''
      picom -b
      ${pkgs.xplugd}/bin/xplugd &
      ${pkgs.haskellPackages.greenclip}/bin/greenclip daemon &
      ${pkgs.sxhkd}/bin/sxhkd &
      if [ -f $HOME/.bin/custom_keyboard_layout ]; then
          $HOME/.bin/custom_keyboard_layout us laptop &
      fi
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "${gtkTheme}";
      # Override to an older commit that still contained the Light theme versions
      # See https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme/issues/42
      package = pkgs.gruvbox-gtk-theme.overrideAttrs (previousAttrs: {
        version = "fixed-version-with-light";
        src = pkgs.fetchFromGitHub {
          owner = "Fausto-Korpsvart";
          repo = "Gruvbox-GTK-Theme";
          rev = "c7a852728717e60a41c2b2fbeac70d2b2269b86c";
          hash = "sha256-sbSQbyvgd3LOnLXuV2ALNckz2mh0O8KB0d6jzfBT1yA=";
        };
      });
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=${toString preferDark}
    '';
    gtk3.extraConfig.gtk-application-prefer-dark-theme = preferDark;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = preferDark;
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark";
    };
  };

  home.pointerCursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-${config.colorScheme.variant}";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  services.network-manager-applet.enable = true;
  services.redshift = {
    enable = true;
    latitude = 48.5;
    longitude = 2.3;
    tray = true;
    temperature = {
      day = 5700;
      night = 3500;
    };
  };

  services.unclutter = {
    enable = true;
    timeout = 5;
  };
  services.xidlehook = {
    enable = true;
    environment = {
      sleep_notif_id = "123497";
    };
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      {
        delay = 600;
        command = "${pkgs.dunst}/bin/dunstify --appname='sleep' --replace=$sleep_notif_id --urgency=critical '⏾ 󰒲' 'About to go to sleep in 10 seconds...'";
        canceller = "${pkgs.dunst}/bin/dunstify --close=$sleep_notif_id";
      }
      {
        delay = 10;
        command = "${pkgs.dunst}/bin/dunstify --close=$sleep_notif_id && ${config.home.homeDirectory}/.bin/farewell Lock && xset dpms force off";
      }
      {
        delay = 600;
        command = "systemctl suspend";
      }
    ];
  };

  programs.autorandr = {
    enable = true;
    hooks.postswitch."myswitch" = ''
      # See https://github.com/phillipberndt/autorandr/issues/326#issuecomment-1426853781 for why this dirty `i3-msg` hack...
      ${pkgs.i3}/bin/i3-msg exec $HOME/.config/polybar/launch.sh

      ${pkgs.feh}/bin/feh --no-fehbg --randomize --bg-fill $HOME/Pictures/Wallpapers/*
      ${pkgs.dunst}/bin/dunstify --appname="display" "Display profile" "$AUTORANDR_CURRENT_PROFILE"
    '';
  };
  xdg.configFile."autorandr/settings.ini".text = ''
    [config]
    skip-options=gamma
  '';

  programs.rofi = {
    enable = true;
    theme = "gruvbox-${config.colorScheme.variant}";
  };
}
