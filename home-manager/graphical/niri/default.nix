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

  wayland.systemd.target = "niri.service";

  programs.niri = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.niri-unstable;
  };

  # programs.swaylock = {
  #   enable = true;
  #   package = null; # swaylock is installed from source on Ubuntu to avoid PAM incompatibility issues
  #   settings =

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
    # Run `shikanectl export <profile-name>`, copy the config to ~/.config/shikane/config.toml,
    # and add the following line under the profile name:
    #   exec = ["notify-send shikane \"Profile $SHIKANE_PROFILE_NAME has been applied\""]
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-left = ["niri/workspaces" "network" "bluetooth" "tray"];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };
        tray = {
          spacing = 10;
        };
        bluetooth = {
          on-click = "rofi-bluetooth &";
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        network = {
          interval = 10;
          format-wifi = "{essid} ";
          format-ethernet = "Ethernet";
          tooltip-format = "{ipaddr} / {ifname} via {gwaddr}";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr} - ↘️ {bandwidthDownBytes} ↗️ {bandwidthUpBytes}";
        };
        modules-right = ["backlight" "pulseaudio" "memory" "cpu" "disk" "battery" "clock"];
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          smooth-scrolling-threshold = 10;
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "shift_reset";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        memory = {
          format = "󰟆 {}%";
        };
        disk = {
          format = "󰋊 {}%";
        };
        backlight = {
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" ""];
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "󰖁    ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            default = [""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
      };
    };
    style =
      /*
      css
      */
      ''
        /* See https://gitlab.gnome.org/GNOME/gtk/-/blob/gtk-3-24/gtk/theme/Adwaita/_colors-public.scss for list of @theme_* color names */

        * {
            font-family: JetBrainsMono NF, Roboto;
            font-size: 13px;
        }

        window#waybar {
            /* font-family: inherit; */
            /* background: @theme_bg_color; */
            /* border-bottom: 1px solid @unfocused_borders; */
            all:unset;
        }

        .modules-left {
            color: @theme_fg_color;
            background: @theme_bg_color;
            border-radius: 0 0 8px 0;
            padding: 2 4 2 2;
        }

        .modules-right {
            color: @theme_fg_color;
            background: @theme_bg_color;
            border-radius: 0 0 0 8px;
            padding: 2 2 2 8;
        }

        #pulseaudio.muted,
        #bluetooth.disabled,
        #bluetooth.off {
            color: #666;
        }

        #workspaces button {
            padding: 0;
            margin: 0 -2px 0 -2px;
        }

        #workspaces button:hover {
            background: @theme_unfocused_bg_color;
        }

        #workspaces button.focused {
            color: @theme_selected_bg_color;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #network,
        #bluetooth,
        #pulseaudio,
        #backlight,
        #tray {
            padding: 0 10px 0 5px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #000000;
            }
        }

        /* Using steps() instead of linear as a timing function to limit cpu usage */
        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: steps(12);
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        label:focus {
            background-color: #000000;
        }

        #network.disconnected {
            background-color: #f53c3c;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
        }
      '';
    systemd = {
      enable = true;
    };
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
