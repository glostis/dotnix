#!/usr/bin/env bash

vol_notif_id="123489"

case "$1" in
    increase)
        pamixer --increase 2
        dunstify --appname="volume" --replace="$vol_notif_id" "Volume change" "$(pamixer --get-volume)%"
        ;;
    decrease)
        pamixer --decrease 2
        dunstify --appname="volume" --replace="$vol_notif_id" "Volume change" "$(pamixer --get-volume)%"
        ;;
    *)
        echo "Usage: $0 {increase|decrease}"
        exit 2
esac
