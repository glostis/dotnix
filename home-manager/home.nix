{ config, pkgs, nixpkgsflake, nix-colors, lib, ... }:

{
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  home.username = "glostis";
  home.homeDirectory = "/home/glostis";

  # Required for packages like spotify, 1password, etc.
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
  home.stateVersion = "23.05";


  home.sessionPath = [
    # Contains all of my custom executable scripts
    "${config.home.homeDirectory}/.bin"
    # programs such as `pipx` put some stuff there
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    # This is used by `alacritty`
    SHELL = "$(which zsh)";

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

  # Make `nix run np#<some-package>` use the same nixpkgs as the one used by this flake
  nix.registry.np.flake = nixpkgsflake;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Make Home-Manager work better on non-NixOS Linux distributions
  targets.genericLinux.enable = true;

  xdg.configFile."alacritty/alacritty.yml".text = ''
    # Configuration for Alacritty, the GPU enhanced terminal emulator.

    env:
      WINIT_X11_SCALE_FACTOR: '1'

    window:
      # Spread additional padding evenly around the terminal content.
      dynamic_padding: true

      # Window padding (changes require restart)
      #
      # Blank space added around the window in pixels. This padding is scaled
      # by DPI and the specified value is always added at both opposing sides.
      padding:
        x: 5
        y: 0

      # Window decorations
      #
      # Values for `decorations`:
      #     - full: Borders and title bar
      #     - none: Neither borders nor title bar
      decorations: none

    # Font configuration
    font:
      # Normal (roman) font face
      normal:
        # Font family
        #
        family: MesloLGS NF

        # The `style` can be specified to pick a specific face.
        # style: Regular

      # Point size
      size: 11.0

    colors:
      primary:
        background:         "#${config.colorScheme.colors.base00}"
        # background-alt:     '#3c3836'
        # background-alt-alt: '#504945'

    # Startup directory
    #
    # Directory the shell is started in. If this is unset, or `None`, the working
    # directory of the parent process will be used.
    working_directory: /home/glostis/

    mouse:
      # If this is `true`, the cursor is temporarily hidden when typing.
      hide_when_typing: true

    key_bindings:
      # Taken from https://github.com/alacritty/alacritty/issues/2930#issuecomment-1059833970
      # This is required to have Control+Backspace work as expected (i.e. delete word)
      # Otherwise, it sends Control+G which switches horizontal pane
      - { key: Back, mods: Control, chars: "\u0017" }
  '';

  # specialisation.imsospecial.configuration = {
  #   home.sessionVariables = lib.mkForce {
  #     SPECIAL = "normal";
  #   };
  # };
}
