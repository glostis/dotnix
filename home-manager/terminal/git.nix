{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-lfs
  ];

  programs.git = {
    enable = true;
    aliases = {
      st = "status -sb";
      co = "checkout";
      sub = "submodule update";
    };
    delta = {
      # Fancy `git diff`
      enable = true;
      options = {
        navigate = true;
        light =
          if ("${config.colorScheme.kind}" == "light")
          then true
          else false;
        syntax-theme = "gruvbox-${config.colorScheme.kind}";
        side-by-side = true;
      };
    };
    ignores = [
      ".ipynb_checkpoints/"
      "__pycache__/"
      ".direnv/"
      ".envrc"
    ];
    includes = [
      {
        path = "~/code-work/.gitconfig";
        condition = "gitdir/i:~/code-work/";
      }
      {
        path = "~/code-perso/.gitconfig";
        condition = "gitdir/i:~/code-perso/";
      }
    ];
    lfs.enable = true;
    extraConfig = {
      diff = {
        colorMoved = "default";
      };
      color = {
        ui = true;
      };
      commit = {
        verbose = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = false;
      };
      pager = {
        branch = false;
      };
    };
  };
}
