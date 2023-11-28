### theme settings ###

# window separators
tmux set-option -wg window-status-separator ""

# monitor window changes
tmux set-option -wg monitor-activity on
tmux set-option -wg monitor-bell on

# set statusbar update interval
tmux set-option -g status-interval 1

### colorscheme ###

theme=$(cat $HOME/.config/alacritty/alacritty.yml | sed -n '/^colors: \*.*$/p' | cut -d\* -f2)
if [ "$theme" = "gruvbox-dark" ]; then
    gvbx_orange="#fe8019"
    gvbx_bg1="#3c3836"
    gvbx_bg="#282828"
    gvbx_fg4="#a89984"
    gvbx_bg4="#7c6f64"
elif [ "$theme" = "gruvbox-light" ]; then
    gvbx_orange="#af3a03"
    gvbx_bg1="#ebdbb2"
    gvbx_bg="#fbf1c7"
    gvbx_fg4="#7c6f64"
    gvbx_bg4="#a89984"
else
    echo "Unknown theme $theme"
    exit 1
fi

# change window screen colors
tmux set-option -wg mode-style bg="$gvbx_orange",fg="$gvbx_bg1"

# default statusbar colors (terminal bg should be $gvbx_bg)
tmux set-option -g status-style bg="$gvbx_bg",fg="$gvbx_fg4"

# default window title colors
tmux set-option -wg window-status-style bg="$gvbx_bg1",fg="$gvbx_bg4"

# colors for windows with activity
tmux set-option -wg window-status-activity-style bg="$gvbx_bg1",fg="$gvbx_fg4"

# colors for windows with bells
tmux set-option -wg window-status-bell-style bg="$gvbx_bg1",fg="$gvbx_orange"

# active window title colors
tmux set-option -wg window-status-current-style bg="$gvbx_orange",fg="$gvbx_bg1"

# pane border
tmux set-option -g pane-active-border-style fg="$gvbx_orange"
tmux set-option -g pane-border-style fg="$gvbx_bg1"

# message info
tmux set-option -g message-style bg="$gvbx_orange",fg="$gvbx_bg1"

# writing commands inactive
tmux set-option -g message-command-style bg="$gvbx_fg4",fg="$gvbx_bg1"

# pane number display
tmux set-option -g display-panes-active-colour "$gvbx_orange"
tmux set-option -g display-panes-colour "$gvbx_bg1"

# clock
tmux set-option -wg clock-mode-colour "$gvbx_orange"

# statusbar formatting
# "#fe8019" MUST be in lowercase here (conflicts with statusline alias otherwise)
tmux set-option -g status-left-length 20
tmux set-option -g status-left "#[fg=$gvbx_bg1, bg=$gvbx_fg4]#{?client_prefix,#[bg=$gvbx_orange] #{host} #[bg=$gvbx_fg4], #{host} }"
tmux set-option -g status-right "#[fg=$gvbx_bg1, bg=$gvbx_fg4]#{?client_prefix,#[bg=$gvbx_orange] %Y-%m-%d %H:%M #[bg=$gvbx_fg4], %Y-%m-%d %H:%M }"

tmux set-option -wg window-status-current-format " #{window_index}#{?window_flags,#F, } #{window_name} "
tmux set-option -wg window-status-format " #{window_index}#{?window_flags,#F, } #{window_name} "
