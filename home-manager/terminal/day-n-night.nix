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

  # stylix.enable = false;
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "day-n-night";
      runtimeInputs = with pkgs; [home-manager gawk neovim-remote];
      text = ''
        niri msg action do-screen-transition
        for gen in $(home-manager generations | awk '{print $5","$7}'); do
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

        systemctl --user restart dunst.service
      '';
    })
  ];

  specialisation.light.configuration = {
    colorScheme = lib.mkForce nix-colors.colorSchemes.gruvbox-light-medium;
  };
}
