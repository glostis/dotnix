{
  config,
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  ...
}: let
  slackOzone = pkgs.makeDesktopItem {
    name = "SlackOzone";
    desktopName = "Slack (Ozone Support)";
    exec = "${pkgs.slack}/bin/slack --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
in {
  home.packages = with pkgs; [
    wdisplays
    shikane
    slackOzone
    xwayland-satellite
  ];

  programs.niri = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.niri-stable;
  };

  systemd.user.services.niri = {
    Unit = {
      Description = "A scrollable-tiling Wayland compositor";
      BindsTo = "graphical-session.target";
      Wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      After = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
    };

    Service = {
      Slice = "session.slice";
      Type = "notify";
      ExecStart = "${config.programs.niri.package}/bin/niri --session";
    };
  };
}
