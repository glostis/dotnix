{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./zsh
    ./neovim
    ./static
    ./git.nix
    ./direnv.nix
    ./open-in-editor.nix
    ./day-n-night.nix
  ];

  home.packages = with pkgs; [
    ntfs3g # For NTFS filesystem (eg USB sticks)
    trash-cli # Use trash-put instead of rm to keep a version of deleted files
    gnumake # `make`
    gcc # C compiler

    ncdu # Curses disk usage explorer
    fzf # Fuzzy finder
    htop # System resources monitoring
    imagemagick # Image manipulation commands
    jq # JSON parser
    gron # Make JSON greppable!
    # neofetch # System information
    tree # Recursive directory listing
    zip # Archiving
    unzip # Unarchiving
    wget # File download
    # python310
    nodePackages.fixjson # JSON formatter
    entr # run arbitrary commands when files change
    bc # Command-line calculations
    pipx # Install executables in python venvs from PyPI
    uv # Python package manager
    parallel # Runs commands in parallel
    usbutils # Provides `lsusb` to show connected USB devices
    gpsbabel # GPS file format swiss-knife
    csvkit # CSV manipulation on the command-line
    pdftk # PDF manipulation on the command-line
    shellcheck # Shell (bash) file linter/LSP
    gh # Github CLI
    pre-commit # Run hooks before committing on a Git repo
    alejandra # Nix file auto-formatter

    pandoc # Document conversion utility
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
        disabled = true;
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
    defaultOptions = ["--reverse"];
    fileWidgetCommand = defaultCommand;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      # Never include the contents of a .git/ directory
      "--glob=!.git/"
      # Always include dotfiles
      "--hidden"
      # Add OSC 8 hyperlinks on file names
      "--hyperlink-format=file-line-column://{path}:{line}:{column}"
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
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

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        linemode = "size";
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
        }
      ];
    };
    plugins = {
      compress = "${inputs.yazi-compress-plugin}";
    };
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
