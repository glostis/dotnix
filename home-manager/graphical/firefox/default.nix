{
  pkgs,
  config,
  enableWorkProfile,
  ...
}: let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox = let
    extensions = with firefox-addons; [
      ublock-origin
      darkreader
      tree-style-tab
      vimium
    ];
    extraConfig = builtins.readFile ./user.js;
    userChrome = builtins.readFile ./userChrome.css;
    userContent = builtins.readFile ./userContent.css;
    search = {
      default = "kagi";
      force = true;
      engines.kagi.urls = [
        {template = "https://kagi.com/search?q={searchTerms}";}
      ];
    };
  in {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox;
    languagePacks = ["fr"];
    profiles = {
      perso = {
        isDefault = !enableWorkProfile;
        id = 0;
        extensions = with firefox-addons;
          extensions
          ++ [
            bitwarden
          ];
        inherit extraConfig search userChrome userContent;
      };
      # This hack makes sure that `profiles.work` does not exist if not enableWorkProfile
      ${
        if enableWorkProfile
        then "work"
        else null
      } = {
        isDefault = true;
        id = 1;
        extensions = with firefox-addons;
          extensions
          ++ [
            onepassword-password-manager
          ];
        inherit extraConfig search userChrome userContent;
      };
    };
  };
}
