#!/usr/bin/env bash

killall -q xidlehook
export sleep_notif_id="123497"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's a audio` \
  --not-when-audio \
  `# Notify the user that the computer is about to go to sleep after 10 minutes of idleness` \
  --timer 600 \
    'dunstify --appname="sleep" --replace="$sleep_notif_id" --urgency=critical "⏾ 鈴" "About to go to sleep in 10 seconds..."' \
    'dunstify --close="$sleep_notif_id"' \
  `# Lock and turn off screen after 10 more seconds` \
  --timer 10 \
    'dunstify --close="$sleep_notif_id" && "$HOME"/.config/i3/scripts/lock.sh Lock && xset dpms force off' \
    '' \
  `# Finally, suspend half an hour after it locks` \
  --timer 1800 \
    'systemctl suspend' \
    ''
