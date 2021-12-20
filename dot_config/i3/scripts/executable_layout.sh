#! /bin/bash

choices="Laptop\nDual - Left\nDual - Top"
choice=$(echo -e "$choices" | rofi -dmenu -i -hide-scrollbar -l 3 -p "Screen layout")
laptop_monitor=$(xrandr | sed -n '/^eDP/p' | cut -d\  -f1)
connected_monitor=$(xrandr | sed -n '/ connected/p' | grep -v '^eDP' | cut -d\  -f1)
disconnected_monitor=$(xrandr | sed -n '/ disconnected/p' | cut -d\  -f1)

command_root="xrandr --output $laptop_monitor"
command_dual="$command_root $(for monitor in $disconnected_monitor; do echo -n "--output $monitor --off "; done) --output $connected_monitor --primary --auto"

case "$choice" in
    Laptop)
        $command_root --primary $(for monitor in $connected_monitor $disconnected_monitor; do echo -n "--output $monitor --off "; done)
        ;;
    "Dual - Left")
        $command_dual --left-of $laptop_monitor
        ;;
    "Dual - Top")
        $command_dual --above $laptop_monitor
        ;;
    *)
        exit 2
esac

bash $HOME/.config/polybar/launch.sh
