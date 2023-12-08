{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password-gui
    # qgis-ltr
    slack
    # vpv      # OpenGL issue
    # ctop     # terminfo issue?
    dive
    act
  ];

  # `awscli` seems very long to install, disabling for now
  # programs.awscli.enable = true;

  # Easy switching between different AWS profiles using `assume`
  programs.granted.enable = true;
}
