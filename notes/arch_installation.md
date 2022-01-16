Download an archiso from [here](https://archlinux.org/download/).

Burn the iso to a USB stick, using `cp` for example, cf [doc](https://wiki.archlinux.org/title/USB_flash_installation_medium#In_GNU/Linux).

Launch the guided installer:
```
archinstall --dry-run --advanced
```

Make sure to include `chezmoi git` to the extra packages to be installed.

Once this is done, inspect the jsons in `/var/log/archinstall/`.
If needed, edit them (especially the disk layout).

Then, run the installer:
```
archinstall --config=/var/log/archinstall/user_configuration.json --disk_layouts=/var/log/archinstall/user_disk_layout.json
```

Once the installation is done, reboot, login, and then run:

```
chezmoi init --apply --verbose glostis
```

This should automatically populate the managed dotfiles, and run the post-install script.
