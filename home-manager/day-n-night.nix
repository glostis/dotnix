{ config, pkgs, nix-colors, lib, ... }:
{
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  xresources.properties = {
    background     = "#${config.colorScheme.colors.base00}";
    background-alt = "#${config.colorScheme.colors.base01}";
    foreground     = "#${config.colorScheme.colors.base06}";
    border         = "#${config.colorScheme.colors.base04}";
    border-alt     = "#${config.colorScheme.colors.base00}";
    orange         = "#${config.colorScheme.colors.base09}";
  };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "day-n-night";
      runtimeInputs = with pkgs; [ home-manager gawk neovim-remote xorg.xrdb i3 ];
      text = ''
        hm_gen=$(home-manager generations | head -n 1 | awk '{print $7}')
        if [ -f "$hm_gen"/specialisation/light/activate ]; then
          "$hm_gen"/specialisation/light/activate
        else
          home-manager --flake ~/dotfiles switch
        fi

        # Use neovim-remote to re-source the colorshcheme.lua module in all existing neovim instances
        for s in $(nvr --serverlist); do
            nvr --nostart --servername "$s" -c "source $HOME/.config/nvim/lua/colorscheme.lua"
        done

        # Relaunch xrdb and i3
        xrdb "$HOME"/.Xresources && i3-msg reload

        # The polybar bars are launched using `--reload` which auto-reloads them when the
        # config changes, so touching the config to "change" it
        touch "$HOME"/.config/polybar/config.ini
      '';
    })
  ];

  specialisation.light.configuration = {
    colorScheme = lib.mkForce nix-colors.colorSchemes.gruvbox-light-medium;
  };
}
