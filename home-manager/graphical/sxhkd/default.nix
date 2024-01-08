{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    sxhkd # Simple X hotkey daemon
  ];

  # The service does not work on my machine, so I launch it directly in xsessions.initExtra
  # services.sxhkd = {
  #   enable = true;
  #   extraConfig = builtins.readFile ./sxhkd/sxhkdrc;
  # };

  xdg.configFile."sxhkd/sxhkdrc".source = ./sxhkdrc;
}
