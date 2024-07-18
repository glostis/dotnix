{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".bin/custom_keyboard_layout" = {
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

        # This script is used to activate my modded Colemak-DH/French touch keyboard layout
        # It uses a mix of XKB (to remap alpha keys, create a one-dead-key, and customize the AltGr layer)
        # and kmonad (to remap non-alpha keys, make sticky modifiers, etc.).
        #
        # It is executed on X startup in ~/.xinitrc, and on keyboard plug/unplug in ~/.config/xplugrc

        kb_type=$1

        kb_files="$HOME"/dotnix/keyboard

        # Sleep to avoid having endless "enter/return" when starting kmonad by hand
        sleep 2

        if [ "$kb_type" = "kinesis" ]; then
            pgrep -af 'kmonad.*kinesis' >/dev/null || kmonad "$kb_files"/kinesis.kbd &
            sleep 1
            ${pkgs.xorg.xkbcomp}/bin/xkbcomp -w 0 "$kb_files"/dist/glostis-colemak.xkb_keymap "$DISPLAY"
        else
            pgrep -af 'kmonad.*laptop' >/dev/null || kmonad "$kb_files"/laptop.kbd &
            sleep 1
            ${pkgs.xorg.xkbcomp}/bin/xkbcomp -w 0 "$kb_files"/dist/glostis-qwerty.xkb_keymap "$DISPLAY"
        fi

        xset r rate 230 50

        echo "All done."
      '';
  };
  home.file.".bin/farewell" = {
    executable = true;
    source = ./farewell;
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
                nmcli radio wifi off
            else
                nmcli radio wifi on
            fi
        elif [[ "$1" = "vpn" ]]; then
            vpn_line=$(nmcli --fields type,name,active connection show | grep '^wireguard')

            connection_name=$(echo $vpn_line | awk '{print $2}')
            connection_active=$(echo $vpn_line | awk '{print $3}')

            if [[ "$connection_active" = "no" ]]; then
                nmcli connection up $connection_name
            else
                nmcli connection down $connection_name
            fi
        elif [[ "$1" = "bluetooth" ]]; then
            if bluetoothctl show | grep -q "Powered: yes"; then
                bluetoothctl power off
            else
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
