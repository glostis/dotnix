#! /bin/bash

sudo mkdir -p /usr/share/wayland-sessions/
cat << 'EOF' | sudo tee /usr/share/wayland-sessions/niri.desktop
[Desktop Entry]
Name=Niri
Comment=A scrollable-tiling Wayland compositor
Exec=niri-session
Type=Application
DesktopNames=niri
EOF
