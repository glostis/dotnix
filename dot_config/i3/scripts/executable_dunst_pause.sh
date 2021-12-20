ispaused=$(dunstctl is-paused)

if [ "$ispaused" = "true" ]; then
    dunstctl set-paused toggle
    dunstify --appname="dunst-pause" --replace="987234" "Notifications turned on"
else
    dunstify --appname="dunst-pause" --replace="987234" "Notifications paused"
    sleep 1
    dunstctl set-paused toggle
fi
