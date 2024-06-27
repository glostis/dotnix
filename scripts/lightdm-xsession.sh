#! /bin/bash

sudo mkdir -p /usr/share/xsessions/
cat << 'EOF' | sudo tee /usr/share/xsessions/guillaume.desktop
[Desktop Entry]
Name=Guillaume's xsession
Exec=/home/glostis/.xsession
EOF
