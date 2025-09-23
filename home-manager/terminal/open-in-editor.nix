{
  config,
  pkgs,
  lib,
  ...
}: let
  # Taken from https://github.com/zeorin/dotfiles/blob/e06b7fe6c36f59f50555b087f12026471b7de41d/pkgs/open-in-editor/default.nix
  # because not (yet?) packaged in nixpkgs
  open-in-editor = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "open-in-editor";
    version = "unstable-2023-06-01";
    src = pkgs.fetchFromGitHub {
      owner = "glostis";
      repo = "open-in-editor";
      rev = "1bd3de5cdb0b4985f3d17a6c7257f959697c2c82";
      hash = "sha256-vS5dOHlk4G+CoDN8c/xfCqnZlVL7EG1VA7j+T3iTQd0=";
    };
    dontConfigure = true;
    dontBuild = true;
    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = let
      desktopItem = pkgs.makeDesktopItem {
        name = finalAttrs.pname;
        desktopName = "OpenInEditor";
        genericName = "Open a file at a certain position";
        comment = "Opens URLs of the type file-line-column://<path>[:<line>[:<column>]] in the configured editor and positions the cursor";
        type = "Application";
        terminal = false;
        noDisplay = true;
        icon = "text-editor";
        exec = "open-in-editor %U";
        categories = [
          "Utility"
          "Core"
        ];
        startupNotify = true;
        mimeTypes = [
          "x-scheme-handler/file-line-column"
          "x-scheme-handler/editor"
        ];
      };
    in ''
      mkdir -p $out/bin
      makeWrapper $src/open-in-editor $out/bin/open-in-editor \
        --prefix PATH : ${lib.makeBinPath [pkgs.python3]}

      mkdir -p "$out/share/applications"
      ln -s "${desktopItem}"/share/applications/* "$out/share/applications/"
    '';
  });
in {
  home.packages = [open-in-editor];
}
