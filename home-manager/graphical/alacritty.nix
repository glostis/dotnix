{ config, pkgs, ... }:
{
  xdg.configFile."alacritty/alacritty.toml".text = /* toml */ ''
    working_directory = "/home/glostis/"

    [colors.normal]
    black   = "#${config.colorScheme.colors.base00}"
    red     = "#${config.colorScheme.colors.base08}"
    green   = "#${config.colorScheme.colors.base0B}"
    yellow  = "#${config.colorScheme.colors.base0A}"
    blue    = "#${config.colorScheme.colors.base0D}"
    magenta = "#${config.colorScheme.colors.base0E}"
    cyan    = "#${config.colorScheme.colors.base0C}"
    white   = "#${config.colorScheme.colors.base06}"

    [colors.primary]
    background = "#${config.colorScheme.colors.base00}"
    foreground = "#${config.colorScheme.colors.base06}"

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
    args = ["--login", "-c", "tmux new-session -A -s session"]
    program = "${pkgs.zsh}/bin/zsh"

    [window]
    decorations = "none"
    dynamic_padding = true

    [window.padding]
    x = 5
    y = 0
  '';
}
