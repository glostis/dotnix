{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.user.services."kanata@" = {
    Unit = {
      Description = "Launch kanata on a given keyboard";
      After = [
        "graphical-session.target"
      ];
    };

    Service = {
      # ExecStartPre = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
      ExecStart = "${pkgs.kanata}/bin/kanata --no-wait -c %h/dotnix/keyboard/%i-kanata.kbd";
      # ExecStopPost = "${config.home.homeDirectory}/.bin/set_niri_keyboard_layout";
    };
  };

  systemd.user.paths."kanata@kinesis" = {
    Unit = {
      Description = "Start kanata for Kinesis";
      StartLimitIntervalSec = 400;
      StartLimitBurst = 3;
    };

    Path = {
      PathChanged = "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.paths."kanata@laptop" = {
    Unit = {
      Description = "Start kanata for laptop";
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

  systemd.user.services."niri-keyboard-layout@" = {
    Unit = {
      Description = "Set Niri keyboard layout for keyboard %i";
      StartLimitIntervalSec = 0; # Disable start limiting
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

  systemd.user.paths."niri-keyboard-layout@laptop" = {
    Unit = {
      StartLimitIntervalSec = 0; # Disable start limiting
    };
    Path = {
      PathChanged = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.paths."niri-keyboard-layout@kinesis" = {
    Unit = {
      StartLimitIntervalSec = 0; # Disable start limiting
    };

    Path = {
      PathChanged = "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.paths."niri-keyboard-layout@corne" = {
    Unit = {
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
