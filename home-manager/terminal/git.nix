{
  config,
  lib,
  pkgs,
  ...
}: let
  lockdiff = pkgs.rustPlatform.buildRustPackage rec {
    pname = "lockdiff";
    version = "2.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "your-tools";
      repo = "lockdiff";
      rev = "${version}";
      sha256 = "1hwiccnnbk7zwk4sxbilsfy0y0jam8l5dgwybxvkqq2fhzj5cyap";
    };
    cargoHash = "sha256-jHsRcPqfI44dhrJp39ynzEwQkl1eJ3YaJrJU+7E6efs=";
  };
in {
  home.packages = with pkgs; [
    git-lfs
    difftastic # a structural diff that understands syntax
    lockdiff
  ];

  home.sessionVariables = {
    DFT_BACKGROUND = "${config.colorScheme.variant}";
  };

  programs.delta = {
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
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      alias = {
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
      diff = {
        # This is hardly readable with `delta`
        colorMoved = "false";
        lockdiff = {
          textconv = "lockdiff";
        };
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
    # Pretty poetry.lock diffs
    # Temporarily disable with `git diff --no-textconv`
    attributes = [
      "poetry.lock diff=lockdiff"
    ];
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
  };
}
