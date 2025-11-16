{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".bin/set_niri_keyboard_layout" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #! ${pkgs.bash}/bin/bash

        # http://redsymbol.net/articles/unofficial-bash-strict-mode
        set -euo pipefail
        IFS=$'\n\t'

        # This script is used to activate one of my keyboard layouts:
        # - the modded Colemak-DH/French touch layout for my external keyboard
        # - the modded QWERTY/French touch layout for my laptop keyboard
        #
        # It is executed on whenever my external keyboard is plugged/unplugged, thanks to
        # the systemd path unit I have made that listens to the device presence on the system.

        if [ -e /dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd ]; then
            layout=colemak
        elif [ -e /dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd ]; then
            layout=colemak
        else
            layout=qwerty
        fi

        cat > "$HOME/.config/niri/keyboard.kdl" <<EOL
        input {
            keyboard {
                xkb {
                    file "~/dotnix/keyboard/dist/glostis-$layout.xkb_keymap"
                }
            }
        }
        EOL
      '';
  };
  home.file.".bin/networking-toggle" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #! ${pkgs.bash}/bin/bash

        if [[ "$1" = "wifi" ]]; then
            state=$(nmcli radio wifi)
            if [[ "$state" = "enabled" ]]; then
                dunstify "Turning wifi off"
                nmcli radio wifi off
            else
                dunstify "Turning wifi on"
                nmcli radio wifi on
            fi
        elif [[ "$1" = "vpn" ]]; then
            state=$(warp-cli --json status | jq -r .status)
            if [[ "$state" = "Connected" ]]; then
                dunstify "Turning VPN off"
                warp-cli disconnect
            else
                dunstify "Turning VPN on"
                warp-cli connect
            fi
        elif [[ "$1" = "bluetooth" ]]; then
            if bluetoothctl show | grep -q "Powered: yes"; then
                dunstify "Turning bluetooth off"
                bluetoothctl power off
            else
                dunstify "Turning bluetooth on"
                bluetoothctl power on
            fi
        fi
      '';
  };
  home.file.".bin/volumectl" = {
    executable = true;
    source = ./volumectl;
  };
  home.file.".bin/fermeadoubletour" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #! ${pkgs.bash}/bin/bash

        # http://redsymbol.net/articles/unofficial-bash-strict-mode
        set -euo pipefail
        IFS=$'\n\t'

        swaylock --daemonize
        if [[ "$1" = "suspend" ]]; then
            systemctl suspend
        fi
      '';
  };
}
