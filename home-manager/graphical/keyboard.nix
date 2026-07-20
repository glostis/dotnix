{
  config,
  pkgs,
  lib,
  ...
}: let
  keyboards = [
    {
      name = "kinesis";
      path = "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
    }
    {
      name = "laptop";
      path = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      kanataPathType = "PathExists";
    }
    {
      name = "corne";
      path = "/dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd";
    }
    {
      name = "quacken";
      path = "/dev/input/by-id/usb-ZMK_Project_Quacken_Flex_E66568714F268421-if02-event-kbd";
    }
  ];

  makeKanataPath = kb: {
    Unit = {
      Description = "Start kanata for ${kb.name}";
      StartLimitIntervalSec = 400;
      StartLimitBurst = 3;
    };

    Path = if (kb.kanataPathType or "PathChanged") == "PathExists" then { PathExists = kb.path; } else { PathChanged = kb.path; };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  makeNiriPath = kb: {
    Unit = {
      StartLimitIntervalSec = 0; # Disable start limiting
    };

    Path = {
      PathChanged = kb.path;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
in {
  systemd.user.services."kanata@" = {
    Unit = {
      Description = "Launch kanata on a given keyboard";
      After = [
        "graphical-session.target"
      ];
    };

    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata --no-wait -c %h/dotnix/keyboard/%i-kanata.kbd";
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

  systemd.user.paths = builtins.listToAttrs (
    map (kb: lib.nameValuePair "kanata@${kb.name}" (makeKanataPath kb))
    keyboards
  ) // builtins.listToAttrs (
    map (kb: lib.nameValuePair "niri-keyboard-layout@${kb.name}" (makeNiriPath kb))
    keyboards
  );
}
