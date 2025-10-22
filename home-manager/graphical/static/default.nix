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
