{
  config,
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  ...
}: let
in {
  home.packages = with pkgs; [
    wdisplays
    shikane
    xwayland-satellite
    waybar
    wofi
    wl-clipboard
  ];

  wayland.systemd.target = "graphical-session.target";

  programs.niri = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.niri-unstable;
  };

  services.cliphist = {
    enable = true;
    allowImages = false; # See https://github.com/nix-community/home-manager/issues/7898
  };

  services.wlsunset = {
    enable = true;
    latitude = 48.5;
    longitude = 2.3;
    temperature = {
      day = 5700;
      night = 3500;
    };
  };

  services.shikane = {
    enable = true;
    # settings = {
    #   profile = [
    #     {
    #       name = "home";
    #       output = [
    #         {
    #           match = "eDP-1";
    #           enable = true;
    #           position = {
    #             x = 1920;
    #             y = 0;
    #           };
    #         }
    #         {
    #           match = "DP-1";
    #           enable = true;
    #           position = {
    #             x = 0;
    #             y = 0;
    #           };
    #         }
    #       ];
    #     }
    #     {
    #       name = "laptop";
    #       output = [
    #         {
    #           match = "eDP-1";
    #           enable = true;
    #         }
    #       ];
    #     }
    #   ];
    # };
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
