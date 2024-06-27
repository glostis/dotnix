sudo vim /usr/share/xsessions/guillaume.desktop
```
[Desktop Entry]
Name=xinitrc
Comment=Executes the .xinitrc script in your home directory
Exec=xinitrcsession-helper
TryExec=xinitrcsession-helper
Type=Application
```

sudo vim /usr/bin/xinitrcsession-helper
```sh
#!/usr/bin/env sh
: "${XINITRC:=$HOME/.xinitrc}"
exec "${XINITRC}"
```

chmod 755 /usr/bin/xinitrcsession-helper
