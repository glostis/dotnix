{ config, pkgs, ... }:
{
  imports = [
    ./zsh
    ./neovim
    ./tmux
    ./git.nix
  ];

  home.packages = with pkgs; [
    xclip                           # clipboard
    xdotool                         # xorg
    ntfs3g                          # For NTFS filestystem (eg USB sticks)
    trash-cli                       # Use trash-put instead of rm to keep a version of deleted files
    gnumake                         # `make`
    gcc                             # C compiler

    ncdu                            # Curses disk usage explorer
    chezmoi                         # Dotfiles manager
    fzf                             # Fuzzy finder
    htop                            # System resources monitoring
    imagemagick                     # Image manipulation commands
    jq                              # JSON parser
    neofetch                        # System information
    ranger                          # File browser (aur)
    tree                            # Recursive directory listing
    zip                             # Archiving
    unzip                           # Unarchiving
    wget                            # File download
    python310
    nodePackages.fixjson            # JSON formatter (aur)
    entr                            # run arbitrary commands when files change
    bc                              # Command-line calculations
    w3m                             # Text-based web browser
    pipx                            # Install executables in python venvs from PyPI
    parallel                        # Runs commands in parallel
    usbutils                        # Provides `lsusb` to show connected USB devices
    gpsbabel                        # GPS file format swiss-knife
    csvkit                          # CSV manipulation on the command-line
    pdftk                           # PDF manipulation on the command-line
    shellcheck                      # Shell (bash) file linter/LSP

    pandoc                          # Document conversion utility (aur)
    bind                            # DNS resolution through `dig`

    ## Stuff that doesn't work

    # Disabled because can't figure out how to start the systemd service when on non-NixOS
    # docker                          # Containers
    # docker-compose                  # Containers
    # docker-buildx

    # Using nix's plocate on non-NixOS is a pain:
    # - doing `sudo updatedb` doesn't work, because `updatedb` is not on super-user's path (`plocate`'s binaries are only installed on my user's path)
    # - cannot find a way to activate the systemd service installed by this package, when not on NixOS
    # mlocate                         # `locate` command
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
      theme = "gruvbox-${config.colorScheme.kind}";
    };
  };

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

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
  };

  programs.gh.enable = true;

  # Need to figure out how to plug-in the index cache
  # programs.nix-index.enable = true;
}
