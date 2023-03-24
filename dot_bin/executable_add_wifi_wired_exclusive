#! /bin/bash

# This script disables Wi-Fi when connected to Ethernet and vice-versa
# Taken from `man nmcli-examples`
# Example 15. nmcli usage in a NetworkManager dispatcher script to make Ethernet and Wi-Fi mutually exclusive
# https://man.archlinux.org/man/nmcli-examples.7.en

cat << 'EOF' | sudo tee /etc/NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh
#!/bin/bash
export LC_ALL=C

enable_disable_wifi ()
{
    result=$(nmcli dev | grep "ethernet" | grep -w "connected")

    if [ -n "$result" ]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
}

if [ "$2" = "up" ]; then
    enable_disable_wifi
fi

if [ "$2" = "down" ]; then
    enable_disable_wifi
fi
EOF

sudo chmod +x /etc/NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh
