#! /bin/bash

vpn_line=$(nmcli --fields type,name,active connection show | grep '^vpn')

connection_name=$(echo $vpn_line | awk '{print $2}')
connection_active=$(echo $vpn_line | awk '{print $3}')

if [[ "$connection_active" = "no" ]]; then
    nmcli connection up $connection_name
else
    nmcli connection down $connection_name
fi
