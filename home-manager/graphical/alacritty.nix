{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "alacritty";
      runtimeInputs = with pkgs; [alacritty];
      text = ''
        if command -v nixGLIntel &> /dev/null
        then
          nixGLIntel alacritty
        else
          alacritty
        fi
      '';
    })
  ];

  xdg.configFile."alacritty/alacritty.toml".text =
    /*
    toml
    */
    ''
      working_directory = "/home/glostis/"

      [colors.normal]
      black   = "#${config.colorScheme.palette.base00}"
      red     = "#${config.colorScheme.palette.base08}"
      green   = "#${config.colorScheme.palette.base0B}"
      yellow  = "#${config.colorScheme.palette.base0A}"
      blue    = "#${config.colorScheme.palette.base0D}"
      magenta = "#${config.colorScheme.palette.base0E}"
      cyan    = "#${config.colorScheme.palette.base0C}"
      white   = "#${config.colorScheme.palette.base06}"

      [colors.primary]
      background = "#${config.colorScheme.palette.base00}"
      foreground = "#${config.colorScheme.palette.base06}"

      [env]
      WINIT_X11_SCALE_FACTOR = "1"

      [font]
      size = 11.0

      [font.normal]
      family = "MesloLGS NF"

      [[keyboard.bindings]]
      # Taken from https://github.com/alacritty/alacritty/issues/2930#issuecomment-1059833970
      # This is required to have Control+Backspace work as expected (i.e. delete word)
      # Otherwise, it sends Control+G which switches horizontal pane
      chars = "\u0017"
      key = "Back"
      mods = "Control"

      [mouse]
      hide_when_typing = true

      [shell]
      args = ["--login", "-c", "tmux new-session -A -s ࿋"]
      program = "${pkgs.zsh}/bin/zsh"

      [window]
      decorations = "none"
      dynamic_padding = true

      [window.padding]
      x = 5
      y = 0
    '';
}
