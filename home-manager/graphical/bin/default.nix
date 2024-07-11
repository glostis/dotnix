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
  home.file.".bin/dunst-pause" = {
    executable = true;
    source = ./dunst-pause;
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
    source = ./monitor-layout;
  };
  home.file.".bin/networking-toggle" = {
    executable = true;
    source = ./networking-toggle;
  };
  home.file.".bin/screenshot" = {
    executable = true;
    source = ./screenshot;
  };
  home.file.".bin/volumectl" = {
    executable = true;
    source = ./volumectl;
  };
}
