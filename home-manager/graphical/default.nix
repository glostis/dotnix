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
    ./static
    ./day-n-night.nix
    ./bin
  ];

  home.packages = with pkgs; [
    ## Graphical applications

    # virtualbox                      # VM
    arandr # GUI to xrandr, to configure monitors
    vlc # Video viewer
    redshift # Turns screen to red to avoid blue light
    libreoffice-fresh # Bureautique
    # bitwarden # Password manager GUI
    gthumb # Quick photo editing
    gimp # Not-so-quick photo editing
    mupdf # pdf viewer
    # spotify                         # Music streaming
    rhythmbox # Local music player
    # gparted # GUI for partioning disks and writing filesystems
    foliate # e-book reader

    ## Window manager
    feh # Background image setter
    maim # Screenshot
    rofi-screenshot # Take screencaptures (.mp4 or .gif)
    rofimoji # Provides an emoji picker using rofi
    haskellPackages.greenclip # Rofi-based clipboard manager
    haskellPackages.kmonad # Advanced keyboard configuration
    nur.repos.glostis.kalamine # Keyboard layout remapping tool
    android-file-transfer # Required to connect to Android phones through USB
    android-udev-rules # Dependency of android-file-transfer
    devour # Open a new program by hiding the current window

    i3 # WM
    libnotify # Provides `notify-send`
    corrupter # Script that "corrupts" an image for i3lock bg
    unclutter-xfixes # Remove mouse cursor when idle
    xidlehook # Trigger action after some time idle
    # polybarFull comes with i3 support
    # This could also be done with just `polybar` with an override to add `i3Support = true;`,
    # but then polybar gets compiled locally which is a bit of a pain.
    polybarFull # Status bar
    xplugd # Execute action on device plug/unplug
    rofi-bluetooth # Rofi front-end to bluetoothctl
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
    meslo-lgs-nf
  ];

  fonts.fontconfig.enable = true;

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = null;
      extraConfig = builtins.readFile ./i3/config;
    };
    # `-m -1` is included in the call to `sxhkd` so that it reacts to keyboard layout changes (see `man sxhkd`).
    initExtra = ''
      picom -b
      ${pkgs.xplugd}/bin/xplugd &
      ${pkgs.haskellPackages.greenclip}/bin/greenclip daemon &
      ${pkgs.sxhkd}/bin/sxhkd -m -1 &
      if [ -f $HOME/.bin/custom_keyboard_layout ]; then
          $HOME/.bin/custom_keyboard_layout laptop &
      fi
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "${gtkTheme}";
      # Override to change the color of the theme
      package = pkgs.gruvbox-gtk-theme.overrideAttrs (previousAttrs: {
        version = "${previousAttrs.version}-patch-orange";
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

  # Using an overlay for `autorandr` because the `programs.autorandr.package` option does not exist,
  # and I want version 1.15 of the package because it suppresses SyntaxWarnings with Python 3.12
  nixpkgs.overlays = [
    (final: prev: {
      autorandr = prev.autorandr.overrideAttrs (previousAttrs: rec {
        version = "1.15";
        src = pkgs.fetchFromGitHub {
          owner = "phillipberndt";
          repo = "autorandr";
          rev = "refs/tags/${version}";
          hash = "sha256-8FMfy3GCN4z/TnfefU2DbKqV3W35I29/SuGGqeOrjNg";
        };
        # Need to do `fish_copletion` → `fish_completion`
        installPhase = ''
          runHook preInstall
          make install TARGETS='autorandr' PREFIX=$out

          # zsh completions exist but currently have no make target, use
          # installShellCompletions for both
          # see https://github.com/phillipberndt/autorandr/issues/197
          installShellCompletion --cmd autorandr \
              --bash contrib/bash_completion/autorandr \
              --zsh contrib/zsh_completion/_autorandr \
              --fish contrib/fish_completion/autorandr.fish
          # In the line above there's a typo that needs to be fixed in the next
          # release

          make install TARGETS='autostart_config' PREFIX=$out DESTDIR=$out

          make install TARGETS='manpage' PREFIX=$man

          ${
            if pkgs.systemd != null
            then ''
              make install TARGETS='systemd udev' PREFIX=$out DESTDIR=$out \
                SYSTEMD_UNIT_DIR=/lib/systemd/system \
                UDEV_RULES_DIR=/etc/udev/rules.d
              substituteInPlace $out/etc/udev/rules.d/40-monitor-hotplug.rules \
                --replace /bin/systemctl "/run/current-system/systemd/bin/systemctl"
            ''
            else ''
              make install TARGETS='pmutils' DESTDIR=$out \
                PM_SLEEPHOOKS_DIR=/lib/pm-utils/sleep.d
              make install TARGETS='udev' PREFIX=$out DESTDIR=$out \
                UDEV_RULES_DIR=/etc/udev/rules.d
            ''
          }

          runHook postInstall
        '';
      });
    })
  ];

  programs.autorandr = {
    enable = true;
    hooks.postswitch."myswitch" = ''
      # See https://github.com/phillipberndt/autorandr/issues/326#issuecomment-1426853781 for why this dirty `i3-msg` hack...
      ${pkgs.i3}/bin/i3-msg exec $HOME/.config/polybar/launch.sh

      ${pkgs.feh}/bin/feh --no-fehbg --randomize --bg-fill $HOME/Pictures/Wallpapers/*
      ${pkgs.dunst}/bin/dunstify --appname="display" "Display profile" "$AUTORANDR_CURRENT_PROFILE"
    '';
  };
  # Skip gamma to avoid `redshift` from interfering, and skip `crtc` due to problems when using a DiplayLink card
  # (see https://github.com/phillipberndt/autorandr/issues/207)
  xdg.configFile."autorandr/settings.ini".text = ''
    [config]
    skip-options=gamma,crtc
  '';

  programs.rofi = {
    enable = true;
    theme = "gruvbox-${config.colorScheme.variant}";
  };
}
