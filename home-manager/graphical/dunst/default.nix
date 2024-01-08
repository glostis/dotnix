{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # dunst  # Notification daemon
  ];

  services.dunst.enable = true;

  xdg.configFile."dunst/dunstrc".text = ''
    # See dunst(5) for all configuration options

    [global]
        monitor = 0
        follow = mouse

        width = 400
        height = 1000
        origin = top-right
        offset = 10x27
        scale = 0
        notification_limit = 0

        # Turn on the progess bar. It appears when a progress hint is passed with
        # for example dunstify -h int:value:12
        progress_bar = true
        progress_bar_height = 10
        progress_bar_frame_width = 1
        progress_bar_min_width = 150
        progress_bar_max_width = 300

        indicate_hidden = yes
        transparency = 0
        separator_height = 2
        padding = 8
        horizontal_padding = 8
        text_icon_padding = 0
        frame_width = 0
        frame_color = "#aaaaaa"
        separator_color = auto
        sort = yes
        idle_threshold = 0

        font = MesloLGS NF:style=Regular:size=12
        line_height = 0
        markup = full
        format = "<b>%s</b>\n%b"
        alignment = center
        vertical_alignment = center
        show_age_threshold = 60
        ellipsize = middle
        ignore_newline = no
        stack_duplicates = true
        hide_duplicate_count = false
        show_indicators = yes

        icon_position = left
        min_icon_size = 0
        max_icon_size = 32
        icon_path = ${pkgs.gruvbox-dark-icons-gtk}/share/icons/oomox-gruvbox-dark/32x32/satus/:${pkgs.gruvbox-dark-icons-gtk}/share/icons/oomox-gruvbox-dark/32x32/devices/

        sticky_history = yes
        history_length = 20

        dmenu = /usr/bin/dmenu -p dunst:
        browser = /usr/bin/xdg-open
        always_run_script = true
        title = Dunst
        class = Dunst
        corner_radius = 6
        ignore_dbusclose = false

        force_xinerama = false
        mouse_left_click = close_current
        mouse_middle_click = do_action, close_current
        mouse_right_click = close_all

    [experimental]
        per_monitor_dpi = false

    [urgency_low]
        background = "#${config.colorScheme.colors.base00}"
        foreground = "#${config.colorScheme.colors.base06}"
        timeout = 3

    [urgency_normal]
        background = "#${config.colorScheme.colors.base00}"
        foreground = "#${config.colorScheme.colors.base06}"
        timeout = 8

    [urgency_critical]
        background = "#900000"
        foreground = "#ffffff"
        frame_color = "#ff0000"
        timeout = 0

    # Remove sleep notifications sent by me from history
    [sleep]
        appname = "sleep"
        history_ignore = yes

    [volume]
        appname = "volume"
        history_ignore = yes
        timeout = 1
        new_icon = "${pkgs.gruvbox-dark-icons-gtk}/share/icons/oomox-gruvbox-dark/32x32/apps/multimedia-volume-control.svg"

    [launchapp]
        appname = "launchapp"
        history_ignore = yes
        timeout = 1

    # vim: ft=cfg
  '';
}
