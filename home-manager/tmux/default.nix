{ config, pkgs, lib, ... }:
let
  tmux-autoreload = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pluginName = "tmux-autoreload";
    version = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
    rtpFilePath = pluginName + ".tmux";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "tmux-autoreload";
      rev = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
      sha256 = "sha256-9Rk+VJuDqgsjc+gwlhvX6uxUqpxVD1XJdQcsc5s4pU4=";
    };
    # nativeBuildInputs = [ entr ];
    postInstall = ''
      sed -i -e 's|entr |${pkgs.entr}/bin/entr |g' $target/tmux-autoreload.tmux
      sed -i -e 's|ps |${pkgs.ps}/bin/ps |g' $target/tmux-autoreload.tmux
    '';
    meta = {
      homepage = "https://github.com/b0o/tmux-autoreload";
      description = "🧐 Automatically reload your tmux config file on change";
      license = lib.licenses.mit;
    };
  };
in
{

  # This is needed for `tmux-autoreload` to work, because ~/.config/tmux/tmux.conf is a symlink
  home.sessionVariables = {
    ENTR_INOTIFY_SYMLINK = "1";
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    escapeTime = 0;
    extraConfig = builtins.readFile ./tmux.conf;
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator  # Seamlessly navigate between nvim splits and tmux panes
      yank                # Copy to system clipboard
      copycat             # Prefix + Ctrl-F,G,U to jump to file, git file, URL
      {
        plugin = extrakto;
        extraConfig = ''
          set -g @extrakto_grab_area 'recent'
          set -g @extrakto_filter_order 'path url all quote word'
        '';
      }
      { # Prefix + y to jump to lots of stuff
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key y
          set -g @thumbs-command 'echo -n {} | xclip -selection c && tmux display-message "Copied {}"'
        '';
      }
      { # Color theme
        plugin = gruvbox;
        extraConfig = "set -g @tmux-gruvbox '${config.colorScheme.kind}'";
      }
      prefix-highlight
      {
        plugin = tmux-autoreload;
        extraConfig = "set-option -g @tmux-autoreload-quiet 1";
      }
    ];
  };
}
