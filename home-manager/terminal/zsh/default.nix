{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    antidote = {
      enable = true;
      plugins = [
        "paulirish/git-open"
        "valiev/almostontop"
        "zsh-users/zsh-completions"
        "wfxr/forgit"
      ];
      useFriendlyNames = true;
    };
    # defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      save = 100000;
      size = 100000;
      share = false;
    };
    initExtra = builtins.readFile ./initextra.zsh;
    syntaxHighlighting.enable = true;
  };
}
