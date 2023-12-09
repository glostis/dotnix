{ config, pkgs, ... }:
{
  # Alacritty v0.13.0 apparently switched to TOML configuration files,
  # but this doesn't seem to be the case in my version of Alacritty yet.
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
        background: "#${config.colorScheme.colors.base00}"
        foreground: "#${config.colorScheme.colors.base06}"

      normal:
        black:   "#${config.colorScheme.colors.base00}"
        red:     "#${config.colorScheme.colors.base08}"
        green:   "#${config.colorScheme.colors.base0B}"
        yellow:  "#${config.colorScheme.colors.base0A}"
        blue:    "#${config.colorScheme.colors.base0D}"
        magenta: "#${config.colorScheme.colors.base0E}"
        cyan:    "#${config.colorScheme.colors.base0C}"
        white:   "#${config.colorScheme.colors.base06}"
        orange:  "#${config.colorScheme.colors.base09}"

    shell:
      program: "${pkgs.zsh}/bin/zsh"
      args:
        - --login
        - -c
        - "tmux new-session -A -s session"

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
}
