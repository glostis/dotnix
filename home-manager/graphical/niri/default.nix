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
    # Dependency of cliphist-wofi-img
    # https://github.com/sentriz/cliphist/blob/efb61cb5b5a28d896c05a24ac83b9c39c96575f2/contrib/cliphist-wofi-img#L40
    gawk
  ];

  wayland.systemd.target = "niri.service";

  # programs.niri = {
  #   enable = true;
  #   package = config.lib.nixGL.wrap pkgs.niri-unstable;
  # };

  xdg.configFile."niri/config.kdl".text =
    /*
    kdl
    */
    ''
      // https://yalter.github.io/niri/Configuration:-Input
      include "${config.home.homeDirectory}/.config/niri/keyboard.kdl"
      input {
          keyboard {
              repeat-delay 230
              repeat-rate 50
          }

          touchpad {
              tap
              natural-scroll
          }
      }
      cursor {
          hide-when-typing
          hide-after-inactive-ms 5000
          xcursor-theme "graphite-${config.colorScheme.variant}"
          xcursor-size 16
      }

      // https://yalter.github.io/niri/Configuration:-Layout
      layout {
          gaps 10

          center-focused-column "never"

          preset-column-widths {
              proportion 0.5
              proportion 0.333
              proportion 0.666
          }

          preset-window-heights {
              proportion 0.5
              proportion 0.333
              proportion 0.666
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              width 2
              active-color "#7fc8ff"
              inactive-color "#505050"
          }
      }

      hotkey-overlay {
          skip-at-startup
      }

      prefer-no-csd

      screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

      // https://yalter.github.io/niri/Configuration:-Window-Rules
      window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
      }

      window-rule {
          match app-id=r#"^1Password$"#
          block-out-from "screen-capture"
      }

      window-rule {
          geometry-corner-radius 8
          clip-to-geometry true
      }

      overview {
          zoom 0.4
      }

      switch-events {
          lid-close { spawn "fermeadoubletour" "suspend"; }
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+Space repeat=false hotkey-overlay-title=null { spawn "ghostty"; }
          Mod+D hotkey-overlay-title=null { spawn-sh "rofi -modi drun -show drun -show-icons"; }
          Mod+Shift+J { spawn "rofimoji"; }
          Mod+G       { spawn-sh "cliphist-wofi-img | wl-copy"; }
          Mod+0       { spawn "slack"; }

          Mod+N       { spawn-sh "networking-toggle wifi"; }
          Mod+Shift+N { spawn "networkmanager_dmenu"; }
          Mod+V       { spawn-sh "networking-toggle vpn"; }
          Mod+B       { spawn-sh "networking-toggle bluetooth"; }
          Mod+Shift+B { spawn "rofi-bluetooth"; }
          Mod+W       { spawn-sh "rofi -show window"; }

          Mod+T       { spawn-sh "day-n-night day"; }
          Mod+Shift+T { spawn-sh "day-n-night night"; }

          Mod+Z allow-when-locked=true hotkey-overlay-title="Lock and suspend" { spawn "fermeadoubletour" "suspend"; }
          Mod+Shift+Z hotkey-overlay-title="Lock" { spawn "fermeadoubletour"; }
          Mod+Ctrl+Shift+Z hotkey-overlay-title="Poweroff" { spawn-sh "systemctl poweroff"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "volumectl increase"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "volumectl decrease"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "pamixer --toggle-mute"; }
          XF86AudioPlay                               { spawn-sh "playerctl play-pause && dunstify --appname=\"volume\" \"Play/pause\""; }
          XF86AudioNext                               { spawn-sh "playerctl next"; }
          XF86AudioPrev                               { spawn-sh "playerctl previous"; }

          // Screen brightness controls
          // Uses https://github.com/Hummer12007/brightnessctl
          // Need to add the user to the `video` group
          XF86MonBrightnessUp allow-when-locked=true { spawn-sh "brightnessctl s +5%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn-sh "brightnessctl s 5%-"; }

          Mod+O repeat=false { toggle-overview; }

          Mod+Q repeat=false { close-window; }

          Mod+X      repeat=false { focus-monitor-next; }
          Mod+Ctrl+X repeat=false { move-workspace-to-monitor-next; }

          Mod+Left  repeat=false { focus-column-or-monitor-left; }
          Mod+Down  repeat=false { focus-window-or-workspace-down; }
          Mod+Up    repeat=false { focus-window-or-workspace-up; }
          Mod+Right repeat=false { focus-column-or-monitor-right; }
          Mod+H     repeat=false { focus-column-or-monitor-left; }
          Mod+J     repeat=false { focus-window-or-workspace-down; }
          Mod+K     repeat=false { focus-window-or-workspace-up; }
          Mod+L     repeat=false { focus-column-or-monitor-right; }

          Mod+Tab repeat=false { focus-window-previous; }

          Mod+Ctrl+Left        repeat=false { move-column-left; }
          Mod+Ctrl+Down        repeat=false { move-window-down; }
          Mod+Ctrl+Up          repeat=false { move-window-up; }
          Mod+Ctrl+Right       repeat=false { move-column-right; }
          Mod+Ctrl+H           repeat=false { move-column-left; }
          Mod+Ctrl+J           repeat=false { move-window-down; }
          Mod+Ctrl+K           repeat=false { move-window-up; }
          Mod+Ctrl+L           repeat=false { move-column-right; }
          Mod+Ctrl+Shift+Left  repeat=false { consume-or-expel-window-left; }
          Mod+Ctrl+Shift+Right repeat=false { consume-or-expel-window-right; }
          Mod+Ctrl+Shift+H     repeat=false { consume-or-expel-window-left; }
          Mod+Ctrl+Shift+L     repeat=false { consume-or-expel-window-right; }

          Mod+Page_Down      repeat=false { focus-workspace-down; }
          Mod+Page_Up        repeat=false { focus-workspace-up; }
          Mod+U              repeat=false { focus-workspace-down; }
          Mod+I              repeat=false { focus-workspace-up; }
          Mod+Ctrl+Page_Down repeat=false { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   repeat=false { move-column-to-workspace-up; }
          Mod+Ctrl+U         repeat=false { move-column-to-workspace-down; }
          Mod+Ctrl+I         repeat=false { move-column-to-workspace-up; }

          Mod+Shift+Page_Down repeat=false { move-workspace-down; }
          Mod+Shift+Page_Up   repeat=false { move-workspace-up; }

          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

          Mod+R       { switch-preset-column-width; }
          Mod+F       { maximize-column; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Shift+F { reset-window-height; }
          Mod+Return  { fullscreen-window; }

          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+C { center-column; }
          Mod+Ctrl+C { center-visible-columns; }

          Mod+Minus       { set-column-width "-10%"; }
          Mod+Equal       { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          Mod+Y            { screenshot; }
          Mod+Ctrl+Y       { screenshot-screen; }
          Mod+Ctrl+Shift+Y { screenshot-window; }

          // Applications such as remote-desktop clients and software KVM switches may
          // request that niri stops processing the keyboard shortcuts defined here
          // so they may, for example, forward the key presses as-is to a remote machine.
          // It's a good idea to bind an escape hatch to toggle the inhibitor,
          // so a buggy application can't hold your session hostage.
          //
          // The allow-inhibiting=false property can be applied to other binds as well,
          // which ensures niri always processes them, even when an inhibitor is active.
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          Mod+Shift+E { quit; }
      }
    '';

  programs.swaylock = {
    enable = true;
    package = null; # swaylock is installed from source on Ubuntu to avoid PAM incompatibility issues
    settings = {
      image = "${config.home.homeDirectory}/Pictures/lock.png";
      scaling = "center";
      color = "#282828";
      ignore-empty-password = true;
      hide-keyboard-layout = true;
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      insensitive = true;
    };
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
    # shikanectl export <profile-name> | sed '/^name/a exec = ["notify-send shikane \\"Profile $SHIKANE_PROFILE_NAME has been applied\\""]' >> ~/.config/shikane/config.toml
    # systemctl --user restart shikane
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
          format = "󰋊 {percentage_used}%";
        };
        backlight = {
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" ""];
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-muted = "󰖁     ";
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

  # systemd.user.services.niri = {
  #   Unit = {
  #     Description = "A scrollable-tiling Wayland compositor";
  #     BindsTo = "graphical-session.target";
  #     Wants = [
  #       "graphical-session-pre.target"
  #       "xdg-desktop-autostart.target"
  #     ];
  #     After = [
  #       "graphical-session-pre.target"
  #       "xdg-desktop-autostart.target"
  #     ];
  #   };
  #
  #   Service = {
  #     Slice = "session.slice";
  #     Type = "notify";
  #     ExecStart = "${config.programs.niri.package}/bin/niri --session";
  #   };
  # };
}
