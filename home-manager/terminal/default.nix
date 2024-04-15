{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh
    ./neovim
    ./tmux
    ./git.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    xclip # clipboard
    xdotool # xorg
    ntfs3g # For NTFS filestystem (eg USB sticks)
    trash-cli # Use trash-put instead of rm to keep a version of deleted files
    gnumake # `make`
    # gcc # C compiler

    ncdu # Curses disk usage explorer
    chezmoi # Dotfiles manager
    fzf # Fuzzy finder
    htop # System resources monitoring
    imagemagick # Image manipulation commands
    jq # JSON parser
    gron # Make JSON greppable!
    neofetch # System information
    ranger # File browser (aur)
    tree # Recursive directory listing
    zip # Archiving
    unzip # Unarchiving
    wget # File download
    # python310
    nodePackages.fixjson # JSON formatter (aur)
    entr # run arbitrary commands when files change
    bc # Command-line calculations
    w3m # Text-based web browser
    pipx # Install executables in python venvs from PyPI
    parallel # Runs commands in parallel
    usbutils # Provides `lsusb` to show connected USB devices
    gpsbabel # GPS file format swiss-knife
    # csvkit fails to build, see https://github.com/NixOS/nixpkgs/pull/291423
    # csvkit # CSV manipulation on the command-line
    pdftk # PDF manipulation on the command-line
    shellcheck # Shell (bash) file linter/LSP
    gh
    pre-commit # Run hooks before committing on a Git repo
    alejandra # Nix file auto-formatter

    pandoc # Document conversion utility (aur)
    bind # DNS resolution through `dig`
  ];

  # Easy directory switching using `z` or `zi`
  programs.zoxide.enable = true;

  # Nice modular shell prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
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
      package = {
        disabled = true;
      };
      shlvl = {
        threshold = 3;
        disabled = false;
        format = "[shlvl $shlvl]($style) ";
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-${config.colorScheme.variant}";
    };
  };

  programs.eza.enable = true;

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

  programs.bash = {
    enable = true;
    profileExtra =
      /*
      bash
      */
      ''
        [[ -f ${config.home.homeDirectory}/.secrets ]] && . ${config.home.homeDirectory}/.secrets
      '';
  };

  xdg.configFile."pypoetry/config.toml".text =
    /*
    toml
    */
    ''
      [virtualenvs]
      in-project = true
      [virtualenvs.options]
      always-copy = true
    '';

  # Need to figure out how to plug-in the index cache
  # programs.nix-index.enable = true;
}
