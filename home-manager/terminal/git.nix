{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-lfs
    difftastic # a structural diff that understands syntax
  ];

  home.sessionVariables = {
    DFT_BACKGROUND = "${config.colorScheme.variant}";
  };

  programs.git = {
    enable = true;
    aliases = {
      st = "status -sb";
      co = "checkout";
      sub = "submodule update";
      # Difftastic aliases, so `git dlog` is `git log` with difftastic and so on.
      # difftastic can’t be configured along with delta in home-manager, they are exclusive options
      # (see https://github.com/nix-community/home-manager/issues/3140)
      dlog = "-c diff.external=difft log --ext-diff";
      dshow = "-c diff.external=difft show --ext-diff";
      ddiff = "-c diff.external=difft diff";
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
        hyperlinks = true;
        # Taken from https://github.com/dandavison/delta/issues/257#issuecomment-663019821
        # See open-in-editor.nix for where this `file-line-column` comes from.
        hyperlinks-file-link-format = "file-line-column://{path}:{line}";
      };
    };
    ignores = [
      ".ipynb_checkpoints/"
      "__pycache__/"
      ".direnv/"
      ".envrc"
      ".env"
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
      rerere = {
        # Remember how merge/rebase conflicts were solved
        enabled = true;
      };
    };
  };
}
