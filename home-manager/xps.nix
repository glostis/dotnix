{
  pkgs,
  nixgl,
  ...
}: let
  slack-wayland-with-desktop = pkgs.slack.overrideAttrs (old: {
    postInstall = ''
      ${old.postInstall or ""}
      wrapProgram $out/bin/slack \
        --add-flags "--ozone-platform=wayland"
      sed -i "s|^Exec=.*|Exec=$out/bin/slack -s %U|" \
        $out/share/applications/slack.desktop
    '';
  });
in {
  home.packages = with pkgs; [
    _1password-gui
    slack-wayland-with-desktop
    dive
  ];

  programs.awscli.enable = true;

  home.sessionVariables = {
    # Make `pipx` use the system python instead of the nix python
    PIPX_DEFAULT_PYTHON = "/bin/python3";
  };

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

  # Make Home-Manager work better on non-NixOS Linux distributions
  targets.genericLinux = {
    enable = true;
    nixGL.packages = nixgl.packages;
    nixGL.installScripts = [ "mesa" ];
  };
}
