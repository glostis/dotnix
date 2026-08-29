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
        # - Ergo-L for my external keyboard
        # - a modded QWERTY-Lafayette for my laptop keyboard
        #
        # It is executed on whenever my external keyboard is plugged/unplugged, thanks to
        # the systemd path unit I have made that listens to the device presence on the system.

        if [ -e /dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd ]; then
            layout=ergol
        elif [ -e /dev/input/by-id/usb-ZMK_Project_Quacken_Flex_E66568714F268421-if02-event-kbd ]; then
            layout=ergol
        else
            layout=qwerty
        fi

        if [ "$layout" = "ergol" ]; then
            xkb="layout \"fr\"
                    variant \"ergol\"
                    options \"compose:rctrl\""
        else
            xkb="file \"~/dotnix/keyboard/dist/glostis-$layout.xkb_keymap\""
        fi
        cat > "$HOME/.config/niri/keyboard.kdl" <<EOL
        input {
            keyboard {
                xkb {
                    $xkb
                }
            }
        }
        EOL

        dunstify "Keyboard layout set to $layout"
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

        lock_dir="$HOME/Pictures/lock"
        if [ -d "$lock_dir" ] && [ -n "$(find "$lock_dir" -type f)" ]; then
            image=$(find "$lock_dir" -type f | shuf -n 1)
            ln -s --force "$image" "$HOME/Pictures/lock.png"
        fi

        swaylock --daemonize
        if [[ "$1" = "suspend" ]]; then
            systemctl suspend
        fi
      '';
  };
}
