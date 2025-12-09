{
  pkgs,
  lib,
  config,
  enableWorkProfile,
  ...
}: let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  ffwork = pkgs.makeDesktopItem {
    name = "ff work";
    desktopName = "ff work";
    exec = "firefox -P work";
    icon = "firefox";
  };
  ffperso = pkgs.makeDesktopItem {
    name = "ff perso";
    desktopName = "ff perso";
    exec = "firefox -P perso";
    icon = "firefox";
  };
in {
  home.packages = with pkgs; [
    ffwork
    ffperso
  ];
  programs.firefox = let
    extensions = with firefox-addons; [
      ublock-origin
      darkreader
      tree-style-tab
      vimium
      french-dictionary
      youtube-no-translation
      refined-github
      # Used https://git.sr.ht/~rycee/mozilla-addons-to-nix to generate the nix code
      (buildFirefoxXpiAddon rec {
        pname = "humble-new-tab";
        version = "1.26.2";
        addonId = "{bb9cfae3-9ac6-4c72-b90b-71814ab7d789}";
        url = "https://addons.mozilla.org/firefox/downloads/file/4511933/humble_new_tab-${version}.xpi";
        sha256 = "c4708739bc3556a86a04b4d70e4d085326b69750dfb51aca32b7f38c0e444eff";
        meta = with lib; {
          homepage = "https://github.com/ibillingsley/HumbleNewTabPage";
          description = "Redesigned new tab page featuring your bookmarks, most visited, recently closed, and weather in a custom layout.";
          license = licenses.mit;
          mozPermissions = ["bookmarks" "topSites" "tabs" "sessions"];
          platforms = platforms.all;
        };
      })
    ];
    extraConfig = builtins.readFile ./user.js;
    userChrome = builtins.readFile ./userChrome.css;
    search = {
      default = "kagi";
      force = true;
      engines.kagi.urls = [
        {template = "https://kagi.com/search?q={searchTerms}";}
      ];
    };
    settings = {
      # Auto-enable extensions after first installation
      # (https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions.packages)
      "extensions.autoDisableScopes" = 0;
    };
  in {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox;
    languagePacks = ["fr"];
    profiles = {
      perso = {
        isDefault = !enableWorkProfile;
        id = 0;
        extensions.packages = with firefox-addons;
          extensions
          ++ [
            bitwarden
          ];
        inherit extraConfig search userChrome settings;
      };
      # This hack makes sure that `profiles.work` does not exist if not enableWorkProfile
      ${
        if enableWorkProfile
        then "work"
        else null
      } = {
        isDefault = true;
        id = 1;
        extensions.packages = with firefox-addons;
          extensions
          ++ [
            onepassword-password-manager
          ];
        inherit extraConfig search userChrome settings;
      };
    };
  };
}
