# glostis' dotfiles

This repository holds my dotfiles, which are managed by [`chezmoi`](https://www.chezmoi.io/).

To get started on a new machine, run:

```
chezmoi init https://github.com/glostis/dotfiles.git
```

Then, to check the changes that would be applied by `chezmoi`, run:

```
chezmoi diff
```

If you're happy with the changes, run:

```
chezmoi update
```

## For Ubuntu

In order to login to the custom i3 desktop environment in a distro that has a login manager (e.g. Ubuntu with `gdm`), you can declare a custom "session" which executes your `.xinitrc` by placing the following content in `/etc/X11/sessions/mysession.desktop`:
```
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Custom session
Comment=This is our custom session
Exec=/home/glostis/.xinitrc
```
