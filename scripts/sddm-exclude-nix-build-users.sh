#! /bin/bash

# Ref: https://github.com/NixOS/nix/issues/7068

sudo mkdir -p /etc/sddm.conf.d/
cat << 'EOF' | sudo tee /etc/sddm.conf.d/nix-build-users
[Users]
MaximumUid=10000
EOF
