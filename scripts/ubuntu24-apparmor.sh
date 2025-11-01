# Needed for Electron apps to work on Ubuntu 24.04
# See https://askubuntu.com/a/1511655
# Otherwise, you get an error looking like:
#
# The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that ... is owned by root and has mode 4755.

echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
  sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf
