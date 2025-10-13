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
        #!/usr/bin/env bash

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
  home.file.".bin/farewell" = {
    executable = true;
    source = ./farewell;
  };
  home.file.".bin/i3lock-multimonitor" = {
    executable = true;
    source = ./i3lock-multimonitor;
  };
  home.file.".bin/launch_application" = {
    executable = true;
    source = ./launch_application;
  };
  home.file.".bin/launch_firefox" = {
    executable = true;
    source = ./launch_firefox;
  };
  home.file.".bin/monitor-layout" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #! ${pkgs.bash}/bin/bash

        choices="autorandr\nLaptop\nDual - Left\nDual - Top"
        choice=$(echo -e "$choices" | rofi -dmenu -i -hide-scrollbar -l 4 -p "Screen layout")
        laptop_monitor=$(xrandr | sed -n '/^eDP/p' | cut -d\  -f1)
        connected_monitor=$(xrandr | sed -n '/ connected/p' | grep -v '^eDP' | cut -d\  -f1)
        disconnected_monitor=$(xrandr | sed -n '/ disconnected/p' | cut -d\  -f1)

        command_root="xrandr --output $laptop_monitor"
        command_dual="$command_root $(for monitor in $disconnected_monitor; do echo -n "--output $monitor --off "; done) --output $connected_monitor --primary --auto"

        case "$choice" in
            autorandr)
                autorandr -c
                ;;
            Laptop)
                $command_root --primary $(for monitor in $connected_monitor $disconnected_monitor; do echo -n "--output $monitor --off "; done)
                ;;
            "Dual - Left")
                $command_dual --left-of $laptop_monitor
                ;;
            "Dual - Top")
                $command_dual --above $laptop_monitor
                ;;
            *)
                exit 2
        esac

        bash ${config.home.homeDirectory}/.config/polybar/launch.sh
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
  home.file.".bin/screenshot" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #! ${pkgs.bash}/bin/bash

        if [ $# -eq 0 ]; then
            mkdir -p "${config.home.homeDirectory}/Pictures"
            filename="${config.home.homeDirectory}/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"

            # Takes a screenshot (by clicking on window or dragging an area of screen), saves it to file,
            # and copies it into the clipboard.
            maim --select --hidecursor --nokeyboard $filename
            xclip -selection clipboard -t image/png $filename
        else
            # Takes a screenshot of the whole screen and saves it to file
            # This is used for the lock screen
            filename=$1
            maim --hidecursor $filename
        fi
      '';
  };
  home.file.".bin/volumectl" = {
    executable = true;
    source = ./volumectl;
  };
}
