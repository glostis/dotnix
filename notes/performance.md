To analyze what takes a long time during the boot process, use:

```
systemd-analyze
```

and to see the load time per systemd service, use:

```
systemd-analyze blame
```
