#! /bin/bash

choices="Laptop\nDual - Left\nDual - Top"
choice=$(echo -e "$choices" | rofi -dmenu -i -hide-scrollbar -lines 3 -p "Screen layout")
connected_monitor=$(xrandr | sed -n '/^DP[12] connected/p' | cut -d\  -f1)
disconnected_monitor=$(xrandr | sed -n '/^DP[12] disconnected/p' | cut -d\  -f1)

command_root="xrandr --output eDP1"
command_dual="$command_root --output $disconnected_monitor --off --output $connected_monitor --primary --auto"

case "$choice" in
    Laptop)
        $command_root --primary --output DP1 --off --output DP2 --off
        ;;
    "Dual - Left")
        $command_dual --left-of eDP1
        ;;
    "Dual - Top")
        $command_dual --above eDP1
        ;;
    *)
        exit 2
esac

bash $HOME/.config/polybar/launch.sh
