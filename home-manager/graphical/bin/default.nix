{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".bin/custom_keyboard_layout" = {
    executable = true;
    source = ./custom_keyboard_layout;
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
