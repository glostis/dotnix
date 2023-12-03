{ pkgs, ... }:
{
  home.packages = with pkgs; [

    ## Graphical applications

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
    gparted                         # GUI for partioning disks and writing filesystems
    foliate                         # e-book reader

    ## Window manager
    feh                             # Background image setter
    maim                            # Screenshot
    rofi-screenshot                 # Take screencaptures (.mp4 or .gif) (aur)
    rofimoji                        # Provides an emoji picker using rofi
    haskellPackages.greenclip       # Rofi-based clipboard manager (aur)
    haskellPackages.kmonad          # Advanced keyboard configuration (aur)
    android-file-transfer           # Required to connect to Android phones through USB
    android-udev-rules              # Dependency of android-file-transfer
    # python-pyaml                    # Dependency of my custom colorswitcher python script
    devour                          # Open a new program by hiding the current window (aur)

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
    unclutter-xfixes                # Remove mouse cursor when idle
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
  ];

  fonts.fontconfig.enable = true;

  xsession.enable = true;

  # To activate later: there are some clashes with ~/.Xresources and ~/.config/gtk-3.0/settings.ini

  # gtk.enable = true;
  # home.pointerCursor = {
  #   package = pkgs.graphite-cursors;
  #   name = "graphite-dark";
  #   size = 16;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };

  # Disabled due to OpenGL issues. NixGL should be a workaround, but seems like a hassle to set up.
  # programs.alacritty.enable = true;
}
