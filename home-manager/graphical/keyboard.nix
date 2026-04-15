{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.user.services."kmonad@" = {
    Unit = {
      Description = "Launch kmonad on a given keyboard";
      After = [
        "graphical-session.target"
      ];
    };

    Service = {
      ExecStartPre = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
      ExecStart = "${pkgs.kmonad}/bin/kmonad %h/dotnix/keyboard/%i.kbd";
      ExecStopPost = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
    };
  };

  systemd.user.services."niri-keyboard-layout@" = {
    Unit = {
      Description = "Set Niri keyboard layout for a given keyboard";
      After = [
        "graphical-session.target"
      ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
      ExecStop = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
    };
  };

  systemd.user.paths."kmonad@kinesis" = {
    Unit = {
      Description = "Start kmonad for Kinesis";
      StartLimitIntervalSec = 400;
      StartLimitBurst = 3;
    };

    Path = {
      PathExists = "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.paths."kmonad@laptop" = {
    Unit = {
      Description = "Start kmonad for laptop";
      StartLimitIntervalSec = 400;
      StartLimitBurst = 3;
    };

    Path = {
      PathExists = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.paths."niri-keyboard-layout@corne" = {
    Unit = {
      Description = "Set Niri keyboard layout for Corne keyboard";
      StartLimitIntervalSec = 0; # Disable start limiting
    };

    Path = {
      PathChanged = "/dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
