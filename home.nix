{ config, pkgs, ... }:

let
  username = "glostis";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  # Remove annoying warning, to solve and remove later on
  home.enableNixpkgsReleaseCheck = false;

  # Required for packages like spotify
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Example of what an overlay can look like
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     polybar = prev.polybar.override {
  #       i3Support = true;
  #     };
  #   })
  # ];


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ## System
    xclip                           # clipboard
    xdotool                         # xorg
    ntfs3g                          # For NTFS filestystem (eg USB sticks)
    trash-cli                       # Use trash-put instead of rm to keep a version of deleted files

    ## Pyenv dependencies
    gcc
    gnumake
    zlib
    libffi
    readline
    bzip2
    openssl
    ncurses

    ## Programs
    # Disabled due to OpenGL issues. NixGL should be a workaround, but seems like a hassle to set up.
    # alacritty                       # Terminal
    # Already handled by programs.firefox
    # firefox                         # Browser
    # virtualbox                      # VM
    arandr                          # GUI to xrandr, to configure monitors
    vlc                             # Video viewer
    # redshift                        # Turns screen to red to avoid blue light
    libreoffice-fresh               # Bureautique
    bitwarden                       # Password manager GUI
    gthumb                          # Quick photo editing
    gimp                            # Not-so-quick photo editing
    mupdf                           # pdf viewer
    spotify                         # Music streaming (aur)
    rhythmbox                       # Local music player
    # qmk                             # Programmable keyboard configuration
    # josm                            # OpenStreetMap editor
    # homebank                        # Personal accounting software
    gparted                         # GUI for partioning disks and writing filesystems
    # postgresql                      # DB
    # postgis                         # Geospatial DB extension
    foliate                         # e-book reader

    ## Terminal programs
    bat                             # Fancy `cat`
    delta                           # Fancy `diff`
    docker                          # Containers
    docker-compose                  # Containers
    # man-db                          # man
    # man-pages                       # man
    # Using nix's plocate on non-NixOS is a pain:
    # - doing `sudo updatedb` doesn't work, because `updatedb` is not on super-user's path (`plocate`'s binaries are only installed on my user's path)
    # - cannot find a way to activate the systemd service installed by this package, when not on NixOS
    # mlocate                         # `locate` command
    ncdu                            # Curses disk usage explorer
    git                             # Version control
    git-lfs                         # Git Large File Storage
    chezmoi                         # Dotfiles manager
    # expac                           # pacman database extraction utility
    # pacman-contrib                  # pacman scripts such as paccache, pacdiff
    # pacutils                        # pacman utils
    # reflector                       # Sort pacman mirrors
    feh                             # Background image setter
    fzf                             # Fuzzy finder
    htop                            # System resources monitoring
    imagemagick                     # Image manipulation commands
    jq                              # JSON parser
    neofetch                        # System information
    neovim                          # Editor
    ranger                          # File browser (aur)
    tmux                            # Terminal multiplexer
    tree                            # Recursive directory listing
    zip                             # Archiving
    unzip                           # Unarchiving
    zsh                             # Shell
    antibody                        # zsh plugin manager (aur)
    wget                            # File download
    ripgrep                         # Fast recursive grep
    maim                            # Screenshot
    rofi-screenshot                 # Take screencaptures (.mp4 or .gif) (aur)
    pyenv                           # Python manager
    # pyenv-virtualenv                # pyenv virtualenv plugin (aur)
    # yay-bin                         # AUR helper (aur)
    nodePackages.fixjson            # JSON formatter (aur)
    # ctags                           # ctags
    entr                            # run arbitrary commands when files change
    bc                              # Command-line calculations
    w3m                             # Text-based web browser
    # python-pip                      # Just pip.
    pipx                            # Install executables in python venvs from PyPI
    parallel                        # Runs commands in parallel
    usbutils                        # Provides `lsusb` to show connected USB devices
    rofimoji                        # Provides an emoji picker using rofi
    # haskellPackages.greenclip       # Rofi-based clipboard manager (aur)
    haskellPackages.kmonad          # Advanced keyboard configuration (aur)
    android-file-transfer           # Required to connect to Android phones through USB
    android-udev-rules              # Dependency of android-file-transfer
    # python-pyaml                    # Dependency of my custom colorswitcher python script
    devour                          # Open a new program by hiding the current window (aur)
    gpsbabel                        # GPS file format swiss-knife
    csvkit                          # CSV manipulation on the command-line
    pdftk                           # PDF manipulation on the command-line
    zoxide                          # Super-powered `cd`
    gh                              # Does what it says: `gh`
    shellcheck                      # Shell (bash) file linter/LSP

    ## Window manager
    i3                              # WM
    dunst                           # Notifications dameon
    lightdm
    lightdm-gtk-greeter             # "Greeter" (login manager)
    # xinit-xsession                  # Enables the use of ~/.xinitrc as a session in greeter (aur)
    i3lock                          # Desktop locker
    # Need to package myself?
    # corrupter-bin                   # Script that "corrupts" an image for i3lock bg (aur)
    # i3-battery-popup-git            # Send notification when battery is low (aur)
    autorandr                       # Multi-monitor
    picom                           # Compositor (aur)
    rofi-unwrapped                  # Launcher
    unclutter                       # Remove mouse cursor when idle
    xidlehook                       # Trigger action after some time idle (aur)
    # polybarFull comes with i3 support
    # This could also be done with just `polybar` with an override to add `i3Support = true;`,
    # but then polybar gets compiled locally which is a bit of a pain.
    polybarFull                     # Status bar
    xplugd                          # Execute action on device plug/unplug (aur)
    rofi-bluetooth                  # Rofi front-end to bluetoothctl (aur)
    networkmanager_dmenu            # Rofi front-end to networkmanager (aur)
    # uswsusp-git                     # Easier hibernation (suspend to disk) (aur)
    sxhkd                           # Simple X hotkey daemon
    # sxhkhm-git                      # Simple X hotkey daemon helper menu (rofi) (aur)
    pandoc                          # Document conversino utility (aur)

    ## Hardware
    # Audio
    alsa-utils
    pamixer
    playerctl
    pulseaudioFull
    pavucontrol
    # Screen backlight
    light
    # Network
    networkmanager
    networkmanagerapplet
    bluez
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

    # Work
    # awscli2
    # _1password-gui
    # qgis-ltr
    # bind
    # slack
    # vpv
    # docker-buildx
    # ctop
    # dive
    # nomad
    # nomad-pack
    # consul
    # act

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/glostis/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # This is used by `alacritty`
    SHELL = "$(which zsh)";
    # This is used by `rofi` to look for desktop applications
    XDG_DATA_DIRS = "${config.home.profileDirectory}/share:/usr/local/share:/usr/share";
  };

  # To activate later: there are some clashes with ~/.Xresources and ~/.config/gtk-3.0/settings.ini

  # gtk.enable = true;
  # home.pointerCursor = {
  #   package = pkgs.graphite-cursors;
  #   name = "graphite-dark";
  #   size = 16;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  xsession.enable = true;

  # Is broken due to OpenGL - should use NixGL instead, but can't be bothered.
  # programs.alacritty.enable = true;

  programs.nix-index.enable = true;

  # Doesn't show up in dmenu/rofi
  programs.firefox = 
  let
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        tree-style-tab
        vimium
    ];
  in
  {
    enable = true;
    profiles.work = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; extensions ++ [
        onepassword-password-manager
      ];
    };
    profiles.perso = {
      isDefault = false;
      id = 1;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; extensions ++ [
        bitwarden
      ];
    };
  };
}
