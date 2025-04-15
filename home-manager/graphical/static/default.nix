{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".config/networkmanager-dmenu/config.ini".text =
    /*
    ini
    */
    ''
      [dmenu]
      dmenu_command = rofi -dmenu -i -l 20
      # (Default: False) use rofi highlighting instead of '=='
      rofi_highlight = True
      # compact = <True or False> # (Default: False). Remove extra spacing from display
      # pinentry = <Pinentry command>  # (Default: None) e.g. `pinentry-gtk`
      # wifi_chars = <string of 4 unicode characters representing 1-4 bars strength>
      # wifi_chars = ▂▄▆█
      # list_saved = <True or False> # (Default: False) list saved connections

      [dmenu_passphrase]
      # # Uses the -password flag for Rofi, -x for bemenu. For dmenu, sets -nb and
      # # -nf to the same color or uses -P if the dmenu password patch is applied
      # # https://tools.suckless.org/dmenu/patches/password/
      # obscure = True
      # obscure_color = #222222

      [editor]
      # terminal = <name of terminal program>
      # gui_if_available = <True or False> (Default: True)
    '';

  home.file.".config/polybar/config.ini".source = ./polybar_config.ini;
  home.file.".config/polybar/launch.sh" = {
    source = ./polybar_launch.sh;
    executable = true;
  };

  home.file.".config/picom.conf".source = ./picom.conf;

  home.file.".config/xplugrc" = {
    executable = true;
    text =
      /*
      bash
      */
      ''
        #!/bin/sh

        # This script is called whenever a new device (mouse, keyboard, monitor) is connected
        # or disconnected.
        #
        # The arguments look like:
        # xplugrc TYPE DEVICE STATUS ["Optional Description"]
        #          |    |      |
        #          |    |       `---- connected or disconnected
        #          |     `----------- HDMI3, LVDS1, VGA1, etc.
        #           `---------------- keyboard, pointer, display

        # FYI: udev sees Bluetooth headsets and some mice as keyboards...
        # So when a Bluetooth headset or mouse is {,dis}connected, it triggers
        # an xplug event with device=keyboard
        if [ "$1" = "keyboard" ]; then
            nb_kinesis=$(find /dev/input/by-id/ -name 'usb-Kinesis_Advantage2_Keyboard*' | wc -l)
            nb_corne=$(find /dev/input/by-id/ -name 'usb-foostan_Corne_v4_vial*' | wc -l)
            if [ "$nb_kinesis" -gt 0 ]; then
                kb_type="kinesis"
            elif [ "$nb_corne" -gt 0 ]; then
                kb_type="corne"
            else
                kb_type="laptop"
            fi
            "$HOME"/.bin/custom_keyboard_layout $kb_type
        fi

        if [ "$1" = "display" ]; then
            autorandr --change
        fi
      '';
  };

  # TODO: variabilize browser between personal and work computer
  home.file.".config/mimeapps.list".text =
    /*
    ini
    */
    ''
      [Default Applications]
      text/html=firefox.desktop
      x-scheme-handler/http=firefox.desktop
      x-scheme-handler/https=firefox.desktop
      x-scheme-handler/about=firefox.desktop
      x-scheme-handler/unknown=firefox.desktop
      application/pdf=mupdf.desktop
      text/plain=nvim.desktop
      text/x-shellscript=nvim.desktop
      image/png=feh.desktop
      image/jpeg=feh.desktop
      image/gif=org.gnome.gThumb.desktop
    '';
}
