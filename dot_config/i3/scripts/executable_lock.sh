#!/usr/bin/env bash

lock() {
    tmpbg="/tmp/screen.png"
    $HOME/.bin/screenshot "$tmpbg"
    convert "$tmpbg" -scale 20% -scale 500% -fill black -colorize 25% "$tmpbg"
    corrupter -add 0 -mag 0 "$tmpbg" "$tmpbg"
    i3lock -i "$tmpbg"
}

if [ -z "$1" ]; then
    choices="Suspend\nLock\nHibernate\nShutdown\nReboot\nLogout"
    choice=$(echo -e "$choices" | rofi -dmenu -i -hide-scrollbar -l 5 -p "Farewell")
else
    choice=$1
fi

case "$choice" in
    Lock)
        lock
        ;;
    Logout)
        i3-msg exit
        ;;
    Suspend)
        lock && systemctl suspend
        ;;
    # For systemctl hibernate to work properly, follow the instructions at:
    # https://wiki.archlinux.org/title/Uswsusp#With_systemd
    Hibernate)
        lock && systemctl hibernate
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {Suspend|Lock|Hibernate|Shutdown|Reboot|Logout}"
        exit 2
esac

exit 0
