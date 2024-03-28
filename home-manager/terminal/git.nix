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
          if ("${config.colorScheme.variant}" == "light")
          then true
          else false;
        syntax-theme = "gruvbox-${config.colorScheme.variant}";
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
        # This is hardly readable with `delta`
        colorMoved = "false";
      };
      color = {
        ui = true;
      };
      commit = {
        verbose = true;
      };
      push = {
        autoSetupRemote = true;
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
