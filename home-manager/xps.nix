{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    qgis
    slack
    # vpv      # OpenGL issue
    ctop # terminfo issue?
    dive
  ];

  # `awscli` seems very long to install, disabling for now
  # programs.awscli.enable = true;

  # Easy switching between different AWS profiles using `assume`
  programs.granted.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets"];
  };
  services.ssh-agent.enable = true;

  # When enabled, xdg.mime was causing issues such as the GTK file picker (used in e.g. Firefox)
  # crashing when trying to open a directory containing a JSON file.
  # This crash could also be reproduced with `gio info file.json`.
  xdg.mime.enable = false;
}
