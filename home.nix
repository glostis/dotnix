{ config, pkgs, nixpkgsflake, ... }:

let
  username = "glostis";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  # Required for packages like spotify
  nixpkgs.config.allowUnfree = true;

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

    ## Terminal programs
    bat                             # Fancy `cat`
    delta                           # Fancy `diff`

    # Disabled because can't figure out how to start the systemd service when on non-NixOS
    # docker                          # Containers
    # docker-compose                  # Containers

    # Using nix's plocate on non-NixOS is a pain:
    # - doing `sudo updatedb` doesn't work, because `updatedb` is not on super-user's path (`plocate`'s binaries are only installed on my user's path)
    # - cannot find a way to activate the systemd service installed by this package, when not on NixOS
    # mlocate                         # `locate` command

    ncdu                            # Curses disk usage explorer
    git                             # Version control
    git-lfs                         # Git Large File Storage
    chezmoi                         # Dotfiles manager
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
    maim                            # Screenshot
    rofi-screenshot                 # Take screencaptures (.mp4 or .gif) (aur)
    python310
    nodePackages.fixjson            # JSON formatter (aur)
    entr                            # run arbitrary commands when files change
    bc                              # Command-line calculations
    w3m                             # Text-based web browser
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
    # gh                              # Does what it says: `gh`
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
    pandoc                          # Document conversion utility (aur)

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

  home.sessionPath = [
    # Contains all of my custom executable scripts
    "${config.home.homeDirectory}/.bin"
  ];
  home.sessionVariables = {
    # This is used by `alacritty`
    SHELL = "$(which zsh)";
    # This is used by `rofi` to look for desktop applications
    XDG_DATA_DIRS = "${config.home.profileDirectory}/share:/usr/local/share:/usr/share";

    EDITOR = "nvim";
    TERMINAL = "alacritty";
    PAGER = "less";

    # ~/ Clean-up:
    # See https://github.com/b3nj5m1n/xdg-ninja for configuration of lots of programs
    LESSHISTFILE = "${config.xdg.configHome}/less/history";
    DVDCSS_CACHE = "${config.xdg.dataHome}/dvdcss";
    IPYTHONDIR = "${config.xdg.configHome}/ipython";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
    W3M_DIR = "${config.xdg.dataHome}/w3m";
    PARALLEL_HOME = "${config.xdg.configHome}/parallel";

    # When set to 1, `z` will print the matched directory before navigating to it.
    _ZO_ECHO=1;

    # `less` with colors
    # Taken from https://wiki.archlinux.org/title/Color_output_in_console#Environment_variables
    LESS = "-R --use-color -Dd+r\\$Du+b\$";

    # `man` with colors
    # Taken from https://github.com/sharkdp/bat#man
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  home.shellAliases = {
      # Need to re-do the pyright shenanigans for nvim, but without pyenv
      v = "nvim";
      x = "exit";
      py = "ipython";
      open = "xdg-open";
      copy = "xclip -selection c";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      l = "eza -la";
      rm = "echo Use trash-put instead. Or use 'backslash rm' if you really want to.; false";
      tp = "trash-put";
      tl = "trash-list";
      ranger = "TERM=screen-256color ranger";
      cm = "chezmoi --source ${config.home.homeDirectory}/dotfiles";
      hm = "home-manager --flake ${config.home.homeDirectory}/dotfiles";
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

  # Make `nix run np#<some-package>` use the same nixpkgs as the one used by this flake
  nix.registry.np.flake = nixpkgsflake;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      git_branch = {
        symbol = " ";
      };
      nix_shell = {
        heuristic = true;
      };
      python = {
        symbol = " ";
      };
      shlvl = {
        threshold = 3;
        disabled = false;
        format = "[shlvl $shlvl]($style) ";
      };
    };
  };

  programs.awscli.enable = true;
  programs.granted.enable = true;

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = rec {
    enable = true;
    defaultCommand = "rg --files --hidden -g '!.git'";
    fileWidgetCommand = defaultCommand;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      # Never include the contents of a .git/ directory
      "--glob=!.git/"
      # Always include dotfiles
      "--hidden"
    ];
  };

  programs.command-not-found.enable = false;

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    antidote = {
      enable = true;
      plugins = [
        "paulirish/git-open"
        "valiev/almostontop"
        "zsh-users/zsh-completions"
        "wfxr/forgit"
      ];
      useFriendlyNames = true;
    };
    # defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      save = 100000;
      size = 100000;
      share = false;
    };
    initExtra = ''
      ### START OF MY CUSTOM zshrc ###

      stty stop undef  # Disable ctrl-s to freeze terminal.

      # Highlight selected completion in the list
      zstyle ':completion:*' menu select

      # Source: https://superuser.com/a/815317
      # 0 -- vanilla completion (abc => abc)
      # 1 -- smart case completion (abc => Abc)
      # 2 -- word flex completion (abc => A-big-Car)
      # 3 -- full flex completion (abc => ABraCadabra)
      zstyle ':completion:*' matcher-list "" \
        'm:{a-z\-}={A-Z\_}' \
        'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
        'r:|?=** m:{a-z\-}={A-Z\_}'
      zmodload zsh/complist

      # Sometimes there's some completion functions in there
      fpath+="$HOME/.zfunc"

      _comp_options+=(globdots)  # Include hidden files.

      # Taken from https://wiki.archlinux.org/index.php/zsh
      # create a zkbd compatible hash;
      # to add other keys to this hash, see: man 5 terminfo
      typeset -g -A key

      key[Home]="''${terminfo[khome]}"
      key[End]="''${terminfo[kend]}"
      key[Delete]="''${terminfo[kdch1]}"
      key[Up]="''${terminfo[kcuu1]}"
      key[Down]="''${terminfo[kcud1]}"
      key[PageUp]="''${terminfo[kpp]}"
      key[PageDown]="''${terminfo[knp]}"
      key[Shift-Tab]="''${terminfo[kcbt]}"

      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      # setup key accordingly
      [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"      beginning-of-line
      [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"       end-of-line
      [[ -n "''${key[Delete]}" ]] && bindkey -- "''${key[Delete]}"       delete-char
      [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"    beginning-of-history
      [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"  end-of-history
      [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}" reverse-menu-complete
      [[ -n "''${key[Up]}"   ]] && bindkey -- "''${key[Up]}"             up-line-or-beginning-search
      [[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}"           down-line-or-beginning-search
      # Control-left/right = move cursor word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      # Control-backspace = delete word
      # From https://stackoverflow.com/a/21252464/9977650
      bindkey '^H' backward-kill-word

      # Finally, make sure the terminal is in application mode, when zle is
      # active. Only then are the values from ''$terminfo valid.
      if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
              autoload -Uz add-zle-hook-widget
              function zle_application_mode_start { echoti smkx }
              function zle_application_mode_stop { echoti rmkx }
              add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
              add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
      fi

      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      ### END OF MY CUSTOM zshrc ###
    '';
    syntaxHighlighting.enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.gh.enable = true;

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
