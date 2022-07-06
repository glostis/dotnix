#!/usr/bin/env bash

# Wait until already running bar instances have been shut down
while pgrep -x polybar >/dev/null; do killall -q polybar; sleep 0.1; done

net_interface=$(ip link | grep '^[0-9]' | sed 's/^.* \([a-z][a-z0-9]*\): .*$/\1/' | grep '^wl')

for m in $(xrandr | sed -n '/ connected /p' | sed 's/ /@/g'); do
    # Looks something like this (for 2 monitors)
    # @0:@+*DP-2@1920/598x1080/336+0+0@@DP-2
    # @1:@+eDP-1@1920/294x1080/165+1920+344@@eDP-1
    monitor=$(echo "$m" | cut -d@ -f1)
    bars="left right"
    if [ "$(echo "$m" | cut -d@ -f3)" = "primary" ]; then
        bars="${bars} center"
    fi
    for bar in $bars; do
        DEFAULT_NETWORK_INTERFACE="$net_interface" MONITOR="$monitor" polybar --reload --log=info "$bar" > /tmp/polybar_"$monitor"_"$bar".log 2>&1 &
    done
    sleep 1
done

echo "Bars launched..."
