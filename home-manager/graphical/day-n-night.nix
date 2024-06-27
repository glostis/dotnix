{
  config,
  pkgs,
  nix-colors,
  lib,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  xresources.properties = {
    background = "#${config.colorScheme.palette.base00}";
    background-alt = "#${config.colorScheme.palette.base01}";
    foreground = "#${config.colorScheme.palette.base06}";
    border = "#${config.colorScheme.palette.base04}";
    border-alt = "#${config.colorScheme.palette.base00}";
    orange = "#${config.colorScheme.palette.base09}";
  };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "day-n-night";
      runtimeInputs = with pkgs; [home-manager gawk neovim-remote xorg.xrdb i3 tmux];
      text = ''
        for gen in $(home-manager generations | awk '{print $5","$7}'); do
          # gen_id=$(echo "$gen" | cut -d, -f1)
          gen_path=$(echo "$gen" | cut -d, -f2)
          if [ -f "$gen_path"/specialisation/light/activate ]; then
            if [ "$1" = "day" ]; then
              dunstify "G'day mate"
              "$gen_path"/specialisation/light/activate
            elif [ "$1" = "night" ]; then
              dunstify "Good night"
              "$gen_path"/activate
            fi
            break
          fi
        done

        # Use neovim-remote to re-source the colorshcheme.lua module in all existing neovim instances
        for s in $(nvr --serverlist); do
            nvr --nostart --servername "$s" -c "source $HOME/.config/nvim/lua/colorscheme.lua" &
        done

        # Relaunch xrdb and i3
        xrdb "$HOME"/.Xresources && i3-msg reload &

        bash "$HOME"/.config/polybar/launch.sh

        tmux source-file "$HOME"/.config/tmux/tmux.conf &
      '';
    })
  ];

  specialisation.light.configuration = {
    colorScheme = lib.mkForce nix-colors.colorSchemes.gruvbox-light-medium;
  };
}
