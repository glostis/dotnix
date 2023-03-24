#! /bin/bash

# As of bluez 5.65, BlueZ' default behavior is to power on all Bluetooth adapters when starting the service or resuming from suspend.
# If you would like the adapter to not be automatically enabled, set AutoEnable=false in /etc/bluetooth/main.conf in the [Policy] section
# Source: https://wiki.archlinux.org/title/Bluetooth#Default_adapter_power_state

sudo sed -i 's/^#\(AutoEnable=\).*$/\1false/' /etc/bluetooth/main.conf
