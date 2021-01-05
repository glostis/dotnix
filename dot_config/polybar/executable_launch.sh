#!/usr/bin/env bash

# Wait until already running bar instances have been shut down
while pgrep -x polybar >/dev/null; do killall -q polybar; sleep 0.1; done

for m in $(xrandr | sed -n '/ connected /p' | sed 's/ /@/g'); do
    # Looks something like this (for 2 monitors)
    # @0:@+*DP-2@1920/598x1080/336+0+0@@DP-2
    # @1:@+eDP-1@1920/294x1080/165+1920+344@@eDP-1
    monitor=$(echo "$m" | cut -d@ -f1)
    if [ "$(echo "$m" | cut -d@ -f3)" = "primary" ]; then
        tray=right
    else
        tray=none
    fi
    for bar in left right; do
        MONITOR="$monitor" TRAY_POSITION="$tray" polybar -l info "$bar" > /tmp/polybar_"$monitor".log 2>&1 &
    done
    sleep 1
done

echo "Bars launched..."
