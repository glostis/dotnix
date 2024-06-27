Getting `uinput` permission errors?

```bash
sudo groupadd uinput
sudo usermod -aG input glostis
sudo usermod -aG uinput glostis
sudo vim /etc/udev/rules.d/kmonad.rules
```
```
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
```

and then reboot.

[source](https://github.com/kmonad/kmonad/blob/master/doc/faq.md#q-how-do-i-get-uinput-permissions)
