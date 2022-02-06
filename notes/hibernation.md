Hibernation is a bit tricky to achieve, here is one way that works:

Follow the documentation at [Uswsusp](https://wiki.archlinux.org/title/Uswsusp)

- My setup uses `zram` for swap, but I did not manage to use that swap for hibernation, so instead
I create a swapfile dedicated to hibernation, by following
[swap file documentation](https://wiki.archlinux.org/title/Swap#Swap_file)
- Also follow [uswsusp with systemd](https://wiki.archlinux.org/title/Uswsusp#With_systemd) to bind
`systemctl hibernate` to the `s2disk` command
