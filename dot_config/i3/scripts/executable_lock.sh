#!/usr/bin/env bash

lock() {
    tmpbg="/tmp/screen.png"
    scrot "$tmpbg"
    convert "$tmpbg" -scale 5% -scale 2000% -fill black -colorize 25% "$tmpbg"
    i3lock -i "$tmpbg"
}

if [ -z "$1" ]; then
    choices="Lock\nSuspend\nShutdown\nReboot\nLogout"
    choice=$(echo -e "$choices" | rofi -dmenu -i -hide-scrollbar -lines 5 -p "Farewell")
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
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {Lock|Suspend|Shutdown|Reboot|Logout}"
        exit 2
esac

exit 0
