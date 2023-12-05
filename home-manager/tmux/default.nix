{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    escapeTime = 0;
    extraConfig = builtins.readFile ./tmux.conf;
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
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
      prefix-highlight
    ];
  };
}
