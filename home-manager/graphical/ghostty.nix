{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    settings = {
      command = "${pkgs.zsh}/bin/zsh";

      theme = "dark:GruvboxDark,light:GruvboxLight";

      # Disable the blinking cursor bar
      shell-integration-features = "no-cursor";
      cursor-style-blink = false;

      # Window styling
      window-decoration = false;
      gtk-tabs-location = "bottom";
      window-padding-x = 4;
      window-padding-y = 2;
      window-padding-balance = true;

      resize-overlay = "never"; # Remove the popup that indicates terminal size on resize
      copy-on-select = "clipboard";

      keybind = [
        # For some reason, the default ctrl+shift+comma doesn’t work with my setup…
        "ctrl+shift+r=reload_config"
      ];
    };
  };

  # This desktop entry overrides the default desktop entry for `nvim`.
  # It is needed to ensure that programs that call `nvim` (through `xdg-open <some-file-whos-mime-matches-nvim>` for
  # example) spawn a new terminal window for it.
  # Otherwise, the `nvim` gets spawned in the background and is inaccessible.
  xdg.desktopEntries = {
    nvim = {
      name = "Neovim in ghostty";
      genericName = "Text editor";
      exec = "ghostty -e nvim %F"; # The default is just `nvim %F`
      terminal = true;
      type = "Application";
      icon = "nvim";
    };
  };
}
