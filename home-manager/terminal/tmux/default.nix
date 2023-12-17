{ config, pkgs, lib, ... }:
{

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
      {                   # Prefix + Tab to select a word/line/url/path
        plugin = extrakto.overrideAttrs (previousAttrs: {
          version = "unstable-2023-11-04";
          src = pkgs.fetchFromGitHub {
            owner = "laktak";
            repo = "extrakto";
            rev = "f8d15d9150f151305cc6da67fc7a0b695ead0321";
            sha256 = "sha256-KaxXwftOFdxEb1N2lFXkpW6sHAOz8QLIWJ6vc9d55/g";
          };
          postInstall = ''
          for f in extrakto.sh open.sh; do
            wrapProgram $target/scripts/$f \
              --prefix PATH : ${with pkgs; lib.makeBinPath (
              [ fzf python3 xclip ]
              )}
          done

          '';
        });
        extraConfig = ''
          set -g @extrakto_grab_area 'recent'
          set -g @extrakto_filter_order 'line word all'
          set -g @extrakto_popup_size '60%,60%'
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
    ];
  };
}
