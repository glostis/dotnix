#!/usr/bin/env bash

lock() {
    tmpbg="/tmp/screen.png"
    rm -f "$tmpbg"
    scrot "$tmpbg"
    convert "$tmpbg" -scale 20% -scale 500% -fill black -colorize 25% "$tmpbg"
    corrupter -add 0 -mag 0 "$tmpbg" "$tmpbg"
    i3lock -i "$tmpbg"
}

if [ -z "$1" ]; then
    choices="Suspend\nLock\nShutdown\nReboot\nHibernate\nLogout"
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
        echo "Usage: $0 {Lock|Suspend|Shutdown|Reboot|Hibernate|Logout}"
        exit 2
esac

exit 0
