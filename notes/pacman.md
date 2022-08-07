To search (remotely) for a package containing a file:

```
pacman -F filename
```

To display extensive information about a given package:

```
pacman -Si package_name
```

To retrieve a list of the files installed by a remote package:

```
pacman -Fl package_name
```

To remove "orphaned" packages (equivalent of `apt autoremove`):

```
pacman -Qdtq | pacman -Rs -
```

To display the direct and reverse dependendy tree of a package:
```
pactree package_name
pactree -r package_name
```

Use `paccache` (from package `pacman-contrib`) to remove the old cached versions of packages. Warning: this only concerns the `pacman` cache, not the `yay` cache for packages installed from the AUR.

Sometimes, when running a `pacman` udpate after not doing so for a long while, you might get errors regarding invalid PGP key signatures or something like that.
This can generally be solved by following [the advice on the Arch wiki](https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly), and/or by running:
```
sudo pacman-key --refresh-keys
```
and then running the `pacman` update.
